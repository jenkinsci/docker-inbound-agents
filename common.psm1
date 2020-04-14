function Make() {
	[CmdletBinding()]
	Param(
		[Parameter(Position=1)]
		[String] $Target = "build",
		[String] $Group = 'jenkins',
		[String] $Prefix = 'jnlp-agent',
		[String] $Suffix = [string]((Get-Location) -split '\\' | Select-Object -Last 1)
	)

	#
	# This is the root module for ensuring that the containers are all built
	# properly

	# To use this module, do:
	# Import-Module -Force -DisableNameChecking -ArgumentList $args ..\common.psm1 ; Make @args

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

	$NAME="${Group}/${Prefix}-${Suffix}:windows"

	function Build() {
		Get-ChildItem -Path * -Include "Dockerfile.windows*" -File | ForEach-Object {
			$fullName='{0}{1}' -f $NAME,[System.IO.Path]::GetExtension($_.FullName).Replace(".windows", "")
			docker build -t $fullName -f $_ .
		}
	}

	function Push() {
		Get-ChildItem -Path * -Include "Dockerfile.windows*" | ForEach-Object {
			$fullName='{0}-{1}' -f $NAME,[System.IO.Path]::GetExtension($_.FullName).Replace(".windows", "")
			docker push $fullName
		}
	}

	switch -wildcard ($Target) {
		"build" { Build }
		"push"  { Push }

		default { Write-Error "No target '$Target'" ; Exit -1 }
	}
}