:Namespace GitHub_UC
⍝ This script directs calls to the GitHub user commands to GitHub itself.
⍝ It's just an interface that does not do anything by itself.
⍝ Version 0.1.0 ⋄ 2024-07-26 ⋄ Kai Jaeger

    ∇ PrintError dummy;msg
      msg←''
      :If 3=⎕NC'⎕SE.GitHub.Version'
          msg←' GitHub is not installed correctly. Please remove and install again.'
      :EndIf
      ⎕←msg
    ∇

    ∇ r←List;ref;c
      r←⍬
     
      c←⎕NS ⍬
      c.(Group Name)←'GitHub' 'ListRepos'
      c.Parse←'1s -verbose -permanent'
      c.Desc←'Returns a list with all repositories for "owner"'
      r,←c
     
      c←⎕NS ⍬
      c.(Group Name)←'GitHub' 'ListIssues'
      c.Parse←'1-2 -verbose -html -filename= -collapse -permanent'
      c.Desc←'Returns a list of open issues for the given owner/project'
      r,←c
      
      c←⎕ns''
      c.(Group Name)←'GitHub' 'GoToGitHub'
      c.Parse←'2s -permanent'
      c.Desc←'Opens the homepage of the given repository on GitHub'
      r,←c
     
      c←⎕NS ⍬
      c.(Group Name Parse)←'GitHub' 'Version' ''
      c.Desc←'Returns the version number for both ]GitHub and ]GitHubAPIv3'
      r,←c
     ⍝Done
    ∇

    ∇ r←level Help cmd;ref
      r←0⍴⊂''
      :If 0=⎕NC'⎕SE.GitHub'
          {}⎕SE.Tatin.LoadDependencies(1⊃⎕NPARTS ##.SourceFile)⎕SE
      :Else
          ref←GetRefToGitHub''
          :If 3=ref.⎕NC'Help'
              r←level ref.Help cmd
          :Else
              PrintError''
          :EndIf
      :EndIf
    ∇

    ∇ r←Run(cmd args);ref
      r←''
      :If 0=⎕NC'⎕SE.GitHub'
          {}⎕SE.Tatin.LoadDependencies(1⊃⎕NPARTS ##.SourceFile)⎕SE
      :Else
          ref←GetRefToGitHub''
          :If 3=ref.⎕NC'Run'
              r←ref.Run(cmd args)
          :Else
              PrintError''
          :EndIf
      :EndIf
    ∇


    ∇ ref←GetRefToGitHub dummy;statuse
      :If 0<⎕SE.⎕NC'Link'
          statuse←⎕SE.Link.Status''
      :AndIf 2=⍴⍴statuse
      :AndIf (⊂'#.GitHub')∊statuse[;1]
      :AndIf 0<⎕SE.GitHub.⎕NC'DEVELOPMENT'
      :AndIf 0<⎕SE.GitHub.DEVELOPMENT
          ref←#.GitHub.GitHub
      :Else
          ref←⎕SE.GitHub.##
      :EndIf
    ∇

:EndNamespace
