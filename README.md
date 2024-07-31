# GitHub

## Overview

`GitHub` offers user commands that use the `GitHubAPIv3` package to communicate with GitHub.

`GitHub` does not have an API: in the event that you want to execute a command under program control check `GitHubAPIv3`'s API: for all user commands there are functions available in the `GitHubAPIv3` package. 

The purpose of the user commands offered via `]GitHub` is to get a better overview than is available on GitHub itself.

## Examples:

Get a list of all repositories for the owener "aplteam":

```
      ]GitHub.ListRepos aplteam
 Name (68)                 
 ---------                 
 ADOC                      
 APLGit2                   
 APLProcess                
 APLTreeUtils2             
 Cider                     
 CodeBrowser               
 CodeCoverage              
 CommTools                 
 Compare                   
 CompareFiles              
 ...
 ZipArchive                
```

Get a list with all issues for the project "aplteam/tatin":

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

Get a detailed list with all issues for the project "aplteam/tatin":

```
      ]GitHub.ListIssues aplteam tatin -verbose
 No.  Title                      Label(s)    Creator   Created at  ≢⍝  Assignee
 ---  -----                      --------    -------   ----------  --  --------
 198  Tatin user command ...                 dyavc     2024-07-30   2
 196  ListPackages: Add  ...  enhancement    aplteam   2024-07-03
 192  Consider switching ...  enhancement    aplteam   2024-06-05   1
 190  ]UpdateTatin should ... enhancement    aplteam   2024-03-26   1
 ...
  70  Add sorting to the ...  enhancement     aplteam   2021-11-01
```

Create a full-blown HTML report on all issues for a project:

```
]GitHub.ListIssues aplteam tatin -html -collapse -filename="/path/2/Issues.html"
```
This statement creates this file:

[/path/2/Issues.html](<https://htmlpreview.github.io/?https://github.com/aplteam/GitHub/master/html/Issues.html>)


