source nu-themes/catppuccin-mocha.nu
source ~/.zoxide.nu

$env.config.show_banner = false
$env.config.buffer_editor = "nvim"

let default_path = "C:\\Users\\Cliente\\Documents\\Projects\\Envs"
let work_path = "C:\\Users\\adinelson.bruhmuller\\Documents\\Projects\\Envs"

# Define a shared environment path constant
let possible_paths = [
    $work_path,
    $default_path
]

let ENV_PATH = ($possible_paths | where { |path| $path | path exists } | first | default $default_path)
$env.ENV_PATH = $ENV_PATH

# Shared function: Copy license file
def copylicense [] {
    echo "copylicense"
    cp ([$ENV_PATH "dev.pfx"] | path join) "dev"
}

# Shared function: Open secrets file in Sublime
def openSecrets [filename: string] {
    let jsonFilePath = ([$ENV_PATH $filename] | path join)
    subl $jsonFilePath
}

# Shared function: Execute secrets script
def executeSecrets [scriptName: string, ...args: string] {
    echo $"Executing Secrets: ($scriptName) with args: ($args)"
    run-external "powershell" "-File" ([$ENV_PATH $scriptName] | path join) ...$args
}

# Shared function: Create symbolic link
def createSymbolicLink [servicePath: string] {
    echo $"Creating Symbolic Link in ($servicePath)"
    let targetDirectory = ($servicePath | path expand)
    let originalDirectory = (pwd)

    if $originalDirectory != $targetDirectory {
        cd $targetDirectory
    }

    if not ("My Project" | path exists) {
        if $nu.os-info.name == "windows" {
            run-external "cmd" "/c" "mklink" "/d" "My Project" "Properties"
        } else {
            run-external "ln" "-s" "Properties" "My Project"
        }
        echo "Symbolic link created successfully."
    } else {
        echo "Symbolic link 'My Project' already exists."
    }

    if $originalDirectory != $targetDirectory {
        cd $originalDirectory
    }
}

# Function to start npm synchronously
def startNpm [ProjectPath: string] {
    echo $"Starting NPM in: ($ProjectPath)"
    cd $ProjectPath
    run-external "npm" "start"
}

# Function to start dotnet synchronously
def startDotnet [ApiPath: string] {
    echo $"Starting Dotnet in: ($ApiPath)"
    cd $ApiPath
    run-external "dotnet" "run" "-lp" "https"
}

# Shared function: Open all project files (Solution + Frontend)
def openAll [solutionFile: string, frontendPath: string, secretsScript: string] {
    echo "Opening full project..."
    executeSecrets $secretsScript
    if $nu.os-info.name == "windows" {
        run-external "start" $solutionFile
    } else {
        run-external "xdg-open" $solutionFile
    }
    job spawn {
      run-external "code" $frontendPath
    }
}

# Shared function: Open frontend only
def openFrontend [frontendPath: string, secretsScript: string] {
    echo "Opening frontend..."
    executeSecrets $secretsScript
    job spawn {
      run-external "code" $frontendPath
    }
}

# Shared function: Open API only
def openApi [solutionFile: string, secretsScript: string] {
    echo "Opening API..."
    executeSecrets $secretsScript
    if $nu.os-info.name == "windows" {
        run-external "start" $solutionFile
    } else {
        run-external "xdg-open" $solutionFile
    }
}

# Restore functions
def allrestore [] {
    run-external "pwsh" "-File" ".\\build\\restore.ps1"
}

def apirestore [] {
    run-external "pwsh" "-File" ".\\build\\restore-api.ps1"
}

def apprestore [] {
    run-external "pwsh" "-File" ".\\build\\restore-app.ps1"
}

# Start application functions
def startApp [frontendPath: string] {
    echo "Starting frontend..."
    copylicense
      let fullPath = ([ (pwd) $frontendPath ] | path join)
    if not ($fullPath | path exists) {
        echo $"Directory does not exist: ($fullPath)"
        return
    }
    startNpm $fullPath
}

def startApi [apiPath: string, setupFunction: closure] {
    echo "Starting API..."
    do $setupFunction
      let fullPath = ([ (pwd) $apiPath ] | path join)
    if not ($fullPath | path exists) {
        echo $"Directory does not exist: ($apiPath)"
        return
    }
    startDotnet $fullPath
}

alias cd = z

def cd-to [target: string] {
    print $target
    let resolved_path = if ($target | path type) == "dir" {
        $target | path expand
    } else if ($target | path type) == "file" {
        $target | path dirname
    } else if ($target | path type) == "symlink" {
        $target | path expand | path dirname
    } else {
        pwd
    }
    print $resolved_path
    print ($resolved_path | path exists)

    cd $resolved_path
}

# def scoop [...args: string] {
#     run-external "pwsh" "-Command" scoop" ...$args
# }


use modules/sts.nu
use modules/qlt.nu

mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

