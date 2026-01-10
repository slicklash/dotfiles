import algorithm, httpclient, net, os, parseopt, re, sequtils, strformat, strutils, tables, terminal

type
  PluginInfo = tuple[filePath: string, name: string, revision: string, locked: bool, errors: seq[string]]
  PluginUpdate = tuple[filePath: string, name: string, revision: string, latestRevision: string]

let REGEX_DEIN_ADD = re"dein#add\('([^']+)'.+"
let REGEX_REVISION = re".+'rev': '([^']+)'"
let REGEX_GITHUB_REVISION = re("\"currentOid\":\"([0-9a-f]+)")

proc showHelp() =
  echo """
  Manage Vim plugin revisions
  -h, --help          : show help
  -c, --check         : check for missing revisions
  -o, --outdated      : list outdated
  -u, --update <name> : update revision
  """

proc byName(a, b: PluginInfo): int = cmp(a.name.toLower, b.name.toLower)
proc padEnd(name: string, length: int): string = fmt"{name.alignString(length, '<', ' ')} "
proc isOutdated(p: PluginInfo, latestRevision: string): bool = not p.locked and p.revision != "next" and p.revision != latestRevision

proc getEnabledLocalPlugins(): seq[PluginInfo] =
  var seen: Table[string, string]
  for filePath in walkDirRec(getEnv("HOME") & "/.vim/rc.plugins"):
    if not filePath.endsWith("rc.on.vim"): continue
    for plugin in readFile(filePath).findAll(REGEX_DEIN_ADD):
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
        result.add((filePath, name, revision, locked, errors))
      seen[name] = revision
  result.sort(byName)

proc check(plugins: seq[PluginInfo]) =
  var hasError: bool
  let maxNameLen = plugins.mapIt(it.name.len).max
  for p in plugins:
    stdout.write p.name.padEnd(maxNameLen)
    if p.revision.isEmptyOrWhitespace:
      stdout.styledWrite(fgRed, "NO_REVISION ")
      echo p.filePath
      hasError = true
    elif p.errors.len > 0:
      stdout.styledWrite(fgRed, "ERROR ")
      stdout.write p.errors[0] & " "
      echo p.filePath
      hasError = true
    else:
      let suffix = if p.locked: " Locked" else: ""
      stdout.styledWriteLine(fgGreen, fmt"OK{suffix}")
  if hasError:
    quit(1)
  else:
    echo "Total: ", plugins.len
    echo "No errors"

proc createHttpClient(): HttpClient =
  newHttpClient(sslContext=newContext(verifyMode=CVerifyPeer))

proc fetchPluginRevision(client: HttpClient, name: string): string =
  let html = client.getContent("https://github.com/" & name)
  let m = html.findAll(REGEX_GITHUB_REVISION)
  result = (if m.len > 0: m[0].substr(m[0].rfind('"') + 1) else: "")

proc confirmUpdate(updates: seq[PluginUpdate])  =
  if updates.len == 0: return
  echo "The following plugins will be updated:"
  for p in updates:
    echo "  ", p.name
  stdout.write "Do you want to continue? [Y/n]"
  let choice = stdin.readLine
  case choice
    of "Y", "y", "":
      for x in updates:
        let (filePath, _, revision, newRevision) = (x[0], x[1], x[2], x[3])
        let content = readFile(filePath)
        writeFile(filePath, content.replace(revision, newRevision))
      echo "Updated"
    else: discard

proc updateOutdated(plugins: seq[PluginInfo]) =
  let httpClient = createHttpClient()
  let maxNameLen = plugins.mapIt(it.name.len).max
  var updates: seq[PluginUpdate] = @[]
  for p in plugins:
    let name = p.name.padEnd(maxNameLen)
    let revision = httpClient.fetchPluginRevision(p.name)
    if revision.isEmptyOrWhitespace:
      stdout.write name
      stdout.styledWriteLine(fgRed, "NOT_FOUND")
    else:
      if p.isOutdated(revision):
        stdout.write name
        echo fmt"https://github.com/{p.name}/compare/{p.revision}..{revision}"
        updates.add((p.filePath, p.name, p.revision, revision))
  confirmUpdate(updates)

proc updateFiltered(plugins: seq[PluginInfo], filters: seq[string]) =
  let httpClient = createHttpClient()
  var updates: seq[PluginUpdate] = @[]
  for p in plugins:
    if filters.anyIt(p.name.contains(it)):
      let latestRevision = httpClient.fetchPluginRevision(p.name)
      if p.isOutdated(latestRevision):
        updates.add((p.filePath, p.name, p.revision, latestRevision))
  confirmUpdate(updates)

when isMainModule:
  if paramCount() == 0:
    showHelp()
    quit(0)

  let plugins = getEnabledLocalPlugins()

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
    of "outdated", "o": updateOutdated(plugins)
    of "update", "u": (if args.len > 0: updateFiltered(plugins, args) else: updateOutdated(plugins))
    else: showHelp()
