# GitHub

> Your repositories and your issues, straight from the APL session.

[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Dyalog](https://img.shields.io/badge/Dyalog-18.2%2B-blue.svg)](https://www.dyalog.com)
[![Tatin](https://img.shields.io/badge/Tatin-aplteam--GitHub-orange.svg)](https://tatin.dev)

`]GitHub` is a small set of user commands that talk to GitHub through the
[`GitHubAPIv3`](https://github.com/aplteam/GitHubAPIv3) package. They exist for one reason: to
give you a **better overview than GitHub itself does**.

Which of my 68 repositories actually need attention? Which issues are assigned to me, across
everything I maintain? On GitHub that is a lot of clicking. Here it is one line, and the answer
comes back as an APL matrix you can sort, filter and compute with, or as a single searchable
HTML report.

```
      ]ListRepos -v -issues -sort=issues
 Name           OI (*)  Description
 ----           ------  -----------
 Tatin              29  Tatin is a package manager for Dyalog APL
 Cider              22  Cider is a Project Manager for Dyalog APL
 CodeBrowser         8  Browse through APL code
 CodeCoverage        6  Collects data on code coverage & creates an HTML report on the data
 Launchy             4  Gui for running selected versions of Dyalog APL with specific parameters
 APLGit2             3  Interface between Git and Dyalog APL
 ...
```

## Installation

```apl
      ]Tatin.InstallPackages aplteam-GitHub [MyUCMDs]
```

Then check that it arrived:

```apl
      ]GitHub -?
```

## The commands

|Command                  |What it does                                                                                              |
|-------------------------|----------------------------------------------------------------------------------------------------------|
|`]GitHub.ListRepos`      |Lists the repositories of an owner, optionally with issue counts and descriptions                         |
|`]GitHub.ListIssues`     |Lists the open issues of one repository, as a table or as a full HTML page                                |
|`]GitHub.ReportAllIssues`|One HTML report covering every repository of an owner                                                     |
|`]GitHub.GoToGitHub`     |Opens a repository (or anything below it) in your browser                                                 |
|`]GitHub.CreateRelease`  |Prints the `gh` command that would create a release, with version, notes and assets taken from the project|

Each takes `-?` for a summary and `-??` for the full syntax, and each is also available as a
function; see [API](#api).

## Examples

### Repositories

All repositories of an owner:

```
      ]GitHub.ListRepos aplteam
 Name (68)
 ---------
 ADOC
 APLGit2
 APLProcess
 APLTreeUtils2
 Cider
 ...
 ZipArchive
```

`-verbose` adds the open-issue count and the description:

```
      ]ListRepos -verbose
 Name                       OI (*)  Description
 ----                       ------  -----------
 ADOC                            2  Automated documentation generation for Dyalog APL
 apl-cation                         Homepage for all members of the APL-Cation project
 APLGit                             Implements an interface to the GitBash from the session
 APLGit2                         3  Interface between Git and Dyalog APL
 APLProcess                      1  Start an APLProcess from within APL
 ...
```

"OI" stands for "open issues". Add `-issues` to drop the quiet repositories, and `-sort=` to
choose the order (`name` or `issues`); with `-issues` the issue count is already the default
order. Forks are left out unless you ask for them with `-forks`.

### Issues

The open issues of one repository:

```
      ]GitHub.ListIssues aplteam tatin
 No.  Title
 ---  -----
 198  Tatin user command does not work after running ]tatin.updatetatin
 196  ListPackages: Add a flag -latest
 192  Consider switching from ZIP to TAR
 190  ]UpdateTatin should allow to update to a specific version
 ...
  70  Add sorting to the columns of tables
```

<details>
<summary><b>With <code>-verbose</code>: labels, creator, date, comment count and assignees</b></summary>

```
      ]GitHub.ListIssues aplteam tatin -verbose
 No.  Title                      Label(s)    Creator   Created at  ≢⍝  Assignees
 ---  -----                      --------    -------   ----------  --  ---------
 198  Tatin user command ...                 dyavc     2024-07-30   2
 196  ListPackages: Add  ...  enhancement    aplteam   2024-07-03
 192  Consider switching ...  enhancement    aplteam   2024-06-05   1
 190  ]UpdateTatin should ... enhancement    aplteam   2024-03-26   1  doe,smith
 ...
  70  Add sorting to the ...  enhancement     aplteam   2021-11-01
```

</details>

With `-html` you get a page rather than a table: every issue with its body, its labels and a link,
all searchable in one go. `-collapse` folds the details away until you want them.

```apl
      ]GitHub.ListIssues aplteam tatin -html -collapse -filename="/path/2/Issues.html"
```

![The generated issue list](ListOfIssues.png)

`-assignees=` filters, and takes more than one name: `-assignees=doe,smith` or, meaning the same,
`-assignees=doe∨smith`.

### One report for everything

`ListIssues` covers a single repository. To sweep every open issue across *all* repositories of an
owner into one HTML report:

```apl
      ]GitHub.ReportAllIssues aplteam
```

The filename is returned; by default it is a temporary file, and `-filename=` chooses your own.
`-raw` hands you the data instead of a report, and `-assignees=` filters exactly as above, which
makes `]GitHub.ReportAllIssues aplteam -assignees=me` a fair answer to "what is on my plate?".

### Jump to GitHub

```apl
      ]GitHub.GoToGitHub aplteam Tatin
      ]GitHub.GoToGitHub aplteam/Tatin           ⍝ Same thing
      ]GitHub.GoToGitHub aplteam/                ⍝ The owner's home page
      ]GitHub.GoToGitHub aplteam/Tatin/issues/1  ⍝ Anything below the repo works too
```

Name no repository at all and the command looks at your open Cider projects: with one open it acts
on that, with several it asks which one you mean.

> On Windows the page opens in your default browser. Elsewhere the command prints `]Open <url>`
> for you to execute.

## Creating a release

Cutting a release means getting a handful of fiddly things exactly right, and the version
number is the one that goes wrong most often: typed from memory, a digit out, or still
carrying a beta suffix that should have gone. `]GitHub.CreateRelease` takes them from the
project instead of from your memory of it.

```apl
      ]GitHub.CreateRelease
```

It prints the `gh` command that would create the release. **It does not run it**, and
nothing is sent to GitHub:

```
gh release create "v0.19.0" --repo "aplteam/GitHub" --title "Version 0.19.0"
   --notes-file "…/ReleaseNotes_1.md" --draft
```

Everything in it was read from the project rather than remembered:

| Part of the release | Comes from |
|---------------------|------------|
| owner and repository | the `project_url` of the Cider config |
| `version` and `tag` | `apl-package.json`; build metadata (`+64`) dropped, and the tag gets the `v` the other tags carry |
| `releaseTitle` | `Version 1.2.3`, from that same version |
| pre-release | the version itself: `0.19.0-beta-1` adds `--prerelease`, and takes its notes from `0.19.0` |
| release notes | the entry for that very version in `History` |
| assets | every file in the distribution folder, named relative to the project; you are asked which of them to attach |

Whatever could **not** be collected is reported above the command, so you find out before
you run it rather than afterwards:

```
*** Not collected:
      release notes (no entry for 0.19.0-beta-1 or 0.19.0 in History)
```

### Tatin packages carry no assets

A Tatin package is not consumed from GitHub: its ZIP is published on <https://tatin.dev>.
Attaching that same ZIP to a GitHub release would offer a second, competing source for it,
so nothing is attached, and a line is added to the bottom of the notes saying where the
package actually comes from:

```
To be consumed as a Tatin package, see https://tatin.dev
```

This is what `tatinPackage` in the collected namespace decides, and it defaults to "the
project has an `apl-package.json`". For anything that is *not* a package — like Tatin — set it to `0` and you are asked which files of the distribution folder to attach:

```apl
      parms←⎕SE.GitHub.CreateReleaseParms
      parms.tatinPackage←0
      ⎕SE.GitHub.PrintReleaseCommand parms ⎕SE.GitHub.CreateRelease ⍬
```

Naturally everything in the distribution folder should belong to the build you are releasing.

### Draft first, fine-tune second

The command carries `--draft`, so running it creates the release **without publishing it**:
nothing is announced, nobody is notified, and it is visible only to you. The draft then sits
on GitHub where the web page is far better than any command line at the things that want
judgement: rewriting the title, editing the notes, adding or dropping assets.

That split is the point. The machine supplies what it can get right by looking (which is
precisely the part that is easiest to get wrong by hand) and you supply the wording.

When it reads the way you want it, press publish on the page.

If you would rather see what was collected than the command built from it, `-raw` hands
you the namespace instead:

```apl
      ]GitHub.CreateRelease -raw
```

## Access tokens

All these commands do is read public data, so you need not worry about authentication, right?
Unfortunately not. Unauthenticated, you get only a limited number of requests per day, and if you
use these commands often you will run out.

The cure is an access token, which you can pass in one of two ways.

### Environment variable (recommended)

Set `GITHUB_ACCESS_TOKEN` to your token and it is picked up automatically. This is the safer
option, and it is the one checked first.

### Config file

In your home directory there is a folder `.config`, hosting (most likely among other stuff) a
folder `dyalog/aplteam/github`. In it lives `github-config.json5`:

```json5
{
  owner: "aplteam",
  access_token: "whatever-your-token-is",
}
```

Create the file if it is not there yet. The `owner` entry saves you from naming it on every call;
the `-permanent` flag writes it for you.

> Keeping a token in a file may not be safe, depending on your circumstances.

## API

Every command is also a function in `⎕SE.GitHub`, so you can drive it under program control.
`GoToGitHub` takes the owner and the repository as a two-item vector; the other three take a
namespace:

| Function | Expects |
|----------|---------|
| `ListRepos` | `owner`, `accessToken`, `verbose`, `issues`, `sort`, `forks` |
| `ListIssues` | `owner`, `repo`, `accessToken`, `verbose`, `html`, `filename`, `collapse`, `assignees` |
| `ReportAllIssues` | `owner`, `accessToken`, `assignees`, `filename`, `raw` |
| `GoToGitHub` | `(owner repo)` |
| `CreateRelease` | a Cider project ref, or `⍬` to work it out |
| `CreateReleaseParms` | nothing: it returns the defaults |
| `PrintReleaseCommand` | what `CreateRelease` returned |

The variables mean what the flags and modifiers of the corresponding user command mean. All of
them must be defined; `accessToken` may be an empty vector.

```apl
      ns←⎕NS''
      ns.owner←'aplteam'
      ns.accessToken←''
      ns.(verbose issues forks)←1 1 0
      ns.sort←'issues'
      ⎕SE.GitHub.ListRepos ns
```

`CreateRelease` takes an optional left argument that beats whatever it collected: a simple
text vector becomes the `releaseTitle`, and a namespace may carry any of the variables
`CreateReleaseParms` creates.

```apl
      parms←⎕SE.GitHub.CreateReleaseParms
      parms.releaseTitle←'Spring release'
      parms.draft←0
      ⎕SE.GitHub.PrintReleaseCommand parms ⎕SE.GitHub.CreateRelease ⍬
```

For direct access to GitHub itself, rather than these overviews, use the
[`GitHubAPIv3`](https://github.com/aplteam/GitHubAPIv3) package.

## Requirements

Dyalog APL 18.2 or later, on Windows, Linux or macOS.

## License

[MIT](LICENSE) — Kai Jaeger

