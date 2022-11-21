import algorithm, httpclient, net, os, parseopt, re, sequtils, strformat, strutils, tables, terminal

type
  PluginInfo = tuple[origin: string, name: string, revision: string, locked: bool, errors: seq[string]]

let REGEX_DEIN_ADD = re"dein#add\('([^']+)'.+"
let REGEX_REVISION = re".+'rev': '([^']+)'"

proc showHelp() =
  echo """
  Manage Vim plugin revisions
  -h, --help          : show help
  -c, --check         : check for missing revisions
  -l, --list          : list remote revisions
  -o, --outdated      : list outdated
  -u, --update <name> : update revision
  """

proc byName(a, b: PluginInfo): int = cmp(a.name, b.name)
proc formatName(name: string, length: int): string = fmt"{name.alignString(length, '<', ' ')} "

proc getPlugins(): seq[PluginInfo] =
  var seen: Table[string, string]
  for origin in walkDirRec("/home/slicklash/.vim/rc.plugins"):
    if not origin.endsWith("rc.on.vim"): continue
    let text = readFile(origin)
    let plugins = text.findAll(REGEX_DEIN_ADD)
    if plugins.len == 0: continue
    for plugin in plugins:
      var name, revision: string
      var locked: bool
      var errors: seq[string] = @[]
      var m: array[1, string]
      if plugin.match(REGEX_DEIN_ADD, m): name = m[0]
      if plugin.match(REGEX_REVISION, m):
        revision = m[0]
        locked = plugin.contains("lock-rev")
      if (seen.contains(name) and seen[name] != revision):
        errors.add(fmt"revision mismatch {revision} != {seen[name]}")
      if errors.len > 0 or not seen.contains(name):
        result.add((origin, name, revision, locked, errors))
      seen[name] = revision
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
      let suffix = if p.locked: " Locked" else: ""
      stdout.styledWriteLine(fgGreen, fmt"OK{suffix}")
  if hasError:
    quit(1)
  else:
    echo "No errors"

proc fetchRevision(client: HttpClient, name: string): string =
  let html = client.getContent("https://github.com/" & name)
  let m = html.findAll(re"permalink.+/tree/[0-9a-f]+")
  result = (if m.len > 0: m[0].substr(m[0].rfind('/') + 1) else: "")

proc list(plugins: seq[PluginInfo], outdated = false) =
  let client = newHttpClient(sslContext=newContext(verifyMode=CVerifyPeer))
  let mlen = plugins.mapIt(it.name.len).max
  for p in plugins:
    let name = formatName(p.name, mlen)
    let revision = fetchRevision(client, p.name)
    if revision.isEmptyOrWhitespace:
      stdout.write name
      stdout.styledWriteLine(fgRed, "NOT_FOUND")
    elif outdated:
      if not p.locked and revision != p.revision and p.revision != "next":
        stdout.write name
        echo fmt"https://github.com/{p.name}/compare/{p.revision}..{revision}"
    else:
      echo name

proc update(plugins: seq[PluginInfo], filters: seq[string]) =
  let client = newHttpClient(sslContext=newContext(verifyMode=CVerifyPeer))
  var target: seq[(string, string, string, string)] = @[]
  for p in plugins:
    if filters.len < 1 or filters.anyIt(p.name.contains(it)):
      let revision = fetchRevision(client, p.name)
      if not p.locked and  revision != p.revision and p.revision != "next":
        target.add((p.origin, p.name, p.revision, revision))
  if target.len == 0: return

  echo "The following plugins will be updated:"
  for t in target:
    echo "  ", t[1]
  stdout.write "Do you want to continue? [Y/n]"
  let choice = stdin.readLine
  case choice
    of "Y", "y", "":
      for x in target:
        let (origin, _, revision, newRevision) = (x[0], x[1], x[2], x[3])
        let content = readFile(origin)
        writeFile(origin, content.replace(revision, newRevision))
    else: discard
  echo "Done"

when isMainModule:
  if paramCount() == 0:
    showHelp()
    quit(0)

  let plugins = getPlugins()

  var cmd: string
  var args: seq[string]

  for kind, key, val in getopt():
    case kind
    of cmdLongOption, cmdShortOption: cmd = key
    of cmdArgument: args.add(key)
    else: discard

  case cmd
    of "help", "h": showHelp()
    of "check", "c": check(plugins)
    of "list", "l": list(plugins)
    of "outdated", "o": list(plugins, true)
    of "update", "u": update(plugins, args)
    else: showHelp()
