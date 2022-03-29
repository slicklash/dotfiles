import algorithm, httpclient, net, os, parseopt, re, sequtils, strformat, strutils, tables, terminal

type
  PluginInfo = tuple[origin: string, name: string, revision: string, errors: seq[string]]

let REGEX_DEIN_ADD = re"dein#add\('([^']+)'.+"
let REGEX_REVISION = re".+'rev': '([^']+)'"

proc showHelp() =
  echo """
  Manage Vim plugin revisions
  -h | --help     : show help
  -c | --check    : check for missing revisions
  -l | --list     : list remote revisions
  -o | --outdated : list outdated
  """

proc byName(a, b: PluginInfo): int = cmp(a.name, b.name)
proc formatName(name: string, length: int): string = fmt"{name.alignString(length, '<', ' ')} "

proc getPlugins(): seq[PluginInfo] =
  var seen: Table[string, string]
  for origin in walkDirRec("/home/slicklash/.vim/rc.plugins"):
    if "rc.on" notin origin: continue
    let text = readFile(origin)
    let plugins = text.findAll(REGEX_DEIN_ADD)
    if plugins.len == 0: continue
    for plugin in plugins:
      var name, revision: string
      var errors: seq[string] = @[]
      var m: array[1, string]
      if plugin.match(REGEX_DEIN_ADD, m): name = m[0]
      if plugin.match(REGEX_REVISION, m): revision = m[0]
      if (seen.contains(name) and seen[name] != revision):
        errors.add(fmt"revision mismatch {revision} != {seen[name]}")
      else:
        seen[name] = revision
      result.add((origin, name, revision, errors))
  result.sort(byName)

proc check(plugins: seq[PluginInfo]) =
  var hasError: bool
  let mlen = plugins.mapIt(it.name.len).max
  for p in plugins:
    stdout.write formatName(p.name, mlen)
    if p.revision.isEmptyOrWhitespace:
      stdout.styledWrite(fgRed, "NO_REVISION ")
      echo p.origin
      hasError = true
    elif p.errors.len > 0:
      stdout.styledWrite(fgRed, "ERROR ")
      stdout.write p.errors[0] & " "
      echo p.origin
      hasError = true
    else:
      stdout.styledWriteLine(fgGreen, "OK")
  if hasError:
    quit(1)
  else:
    echo "No errors"

proc list(plugins: seq[PluginInfo], outdated = false) =
  let client = newHttpClient(sslContext=newContext(verifyMode=CVerifyPeer))
  let mlen = plugins.mapIt(it.name.len).max
  for p in plugins:
    let html = client.getContent("https://github.com/" & p.name)
    let m = html.findAll(re"permalink.+/tree/[0-9a-f]+")
    let revision = (if m.len > 0: m[0].substr(m[0].rfind('/') + 1) else: "")
    let name = formatName(p.name, mlen)
    if revision.isEmptyOrWhitespace:
      stdout.write name
      stdout.styledWriteLine(fgRed, "NOT_FOUND")
    elif outdated:
      if revision != p.revision and p.revision != "next":
        stdout.write name
        stdout.styledWrite(fgRed, p.revision.alignString(41, '<', ' '))
        stdout.styledWriteLine(fgGreen, revision)
    else:
      echo name

when isMainModule:
  if paramCount() == 0:
    showHelp()
    quit(0)

  let plugins = getPlugins()

  for kind, key, val in getopt():
    case kind
    of cmdLongOption, cmdShortOption:
      case key
      of "help", "h": showHelp()
      of "check", "c": check(plugins)
      of "list", "l": list(plugins)
      of "outdated", "o": list(plugins, true)
      else: discard
    else: discard
