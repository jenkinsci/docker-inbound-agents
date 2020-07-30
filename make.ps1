[CmdletBinding()]
Param(
    [Parameter(Position=1)]
	[String] $Target = 'build',
	[String] $Group = 'jenkins',
	[String] $Prefix = 'jnlp-agent'
)

#
# This is the root make.ps1 for ensuring that the containers are all built
# properly

# GROUP can be overridden in the environment to root the docker images under
# different registry namespace
if(![System.String]::IsNullOrWhiteSpace($env:GROUP)) {
	$Group = $env:GROUP
}

# PREFIX defaults to `jnlp-agent` and can be changed to compute different image
# names
if(![System.String]::IsNullOrWhiteSpace($env:PREFIX)) {
	$Prefix = $env:PREFIX
}

function Build() {
	Get-ChildItem -Include "Dockerfile.windows*" -File -Recurse | Split-Path -Parent | Get-Unique | ForEach-Object {
		Push-Location $_
		try {
			.\make.ps1 -Target build -Group "$Group" -Prefix "$Prefix"
		} finally {
			Pop-Location
		}
	}
}

function Push() {
	Build
	Get-ChildItem -Include "Dockerfile.windows*" -File -Recurse | Split-Path -Parent | Get-Unique | ForEach-Object {
		Push-Location $_
		try {
			.\make.ps1 -Target push -Group "$Group" -Prefix "$Prefix"
		} finally {
			Pop-Location
		}
	}
}

function Clean() {
	docker images -qf "reference=${Group}/${Prefix}*" | ForEach-Object { docker rmi $_ }
}

switch -wildcard ($Target) {
	"build" { Build }
	"check" { Build }
	"clean" { Clean }
	"push"  { Push }

    default { Write-Error "No target '$Target'" ; Exit -1 }
}