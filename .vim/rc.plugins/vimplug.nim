import algorithm, asyncdispatch, httpclient, net, os, parseopt, re, sequtils, strformat, strutils, tables, terminal

type
  PluginInfo = tuple[filePath, name, revision: string, locked: bool, error: string]
  PluginUpdate = tuple[filePath, name, revision, latestRevision: string]

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
      let name = if plugin =~ REGEX_DEIN_ADD: matches[0] else: ""
      let revision = if plugin =~ REGEX_REVISION: matches[0] else: ""
      let locked = revision != "" and plugin.contains("lock-rev")
      let error = if name in seen and seen[name] != revision: fmt"revision mismatch {revision} != {seen[name]}" else: ""
      if error != "" or name notin seen:
        result.add((filePath, name, revision, locked, error))
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
    elif p.error != "":
      stdout.styledWrite(fgRed, "ERROR ")
      echo p.error, " ", p.filePath
      hasError = true
    else:
      let suffix = if p.locked: " Locked" else: ""
      stdout.styledWriteLine(fgGreen, fmt"OK{suffix}")
  if hasError:
    quit(1)
  echo "Total: ", plugins.len
  echo "No errors"

proc fetchPluginRevision(client: AsyncHttpClient, name: string): Future[string] {.async.} =
  let html = await client.getContent("https://github.com/" & name)
  var m: array[1, string]
  result = if html.find(REGEX_GITHUB_REVISION, m) >= 0: m[0] else: ""

proc fetchPluginRevisions(names: seq[string], concurrency = 4): seq[string] =
  var revisions = newSeq[string](names.len)
  var next = 0
  proc worker() {.async.} =
    let client = newAsyncHttpClient(sslContext=newContext(verifyMode=CVerifyPeer))
    defer: client.close()
    while next < names.len:
      let i = next
      inc next
      try:
        revisions[i] = await client.fetchPluginRevision(names[i])
      except CatchableError:
        revisions[i] = ""
  waitFor all(toSeq(0 ..< min(concurrency, names.len)).mapIt(worker()))
  revisions

proc confirmUpdate(updates: seq[PluginUpdate]) =
  if updates.len == 0: return
  echo "The following plugins will be updated:"
  for u in updates:
    echo "  ", u.name
  stdout.write "Do you want to continue? [Y/n]"
  if stdin.readLine.toLower in ["y", ""]:
    for u in updates:
      writeFile(u.filePath, readFile(u.filePath).replace(u.revision, u.latestRevision))
    echo "Updated"

proc update(plugins: seq[PluginInfo], filters: seq[string]) =
  var selected: seq[PluginInfo]
  for p in plugins:
    if filters.len == 0 or filters.anyIt(p.name.contains(it)): selected.add(p)
  if selected.len == 0: return
  let maxNameLen = selected.mapIt(it.name.len).max
  let revisions = fetchPluginRevisions(selected.mapIt(it.name))
  var updates: seq[PluginUpdate]
  for i, p in selected:
    let latestRevision = revisions[i]
    if latestRevision.isEmptyOrWhitespace:
      stdout.write p.name.padEnd(maxNameLen)
      stdout.styledWriteLine(fgRed, "NOT_FOUND")
    elif p.isOutdated(latestRevision):
      stdout.write p.name.padEnd(maxNameLen)
      echo fmt"https://github.com/{p.name}/compare/{p.revision.substr(0, 9)}..{latestRevision.substr(0, 9)}"
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
    of "outdated", "o", "update", "u": update(plugins, args)
    else: showHelp()
