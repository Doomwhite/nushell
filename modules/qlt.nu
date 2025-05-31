const secretsScript = "setup-user-secrets-quality.ps1"
const solutionPath = ".\\Quality.sln"
const frontendPath = ".\\src\\Movtech.Quality.Presentation.Web"
const apiPath = ".\\src\\Movtech.Quality.Services.Api"

export def setup [] {
    echo "setup"
    copylicense
    mklink
    secrets
}

export def mklink [] {
    createSymbolicLink $apiPath
}

export def secretsopen [] {
    openSecrets $secretsScript
}

export def secrets [...args: string] {
    executeSecrets $secretsScript ...$args
}

export def open [] {
    openAll $solutionPath $frontendPath $secretsScript
}

export def appopen [] {
    openFrontend $frontendPath $secretsScript
}

export def apiopen [] {
    openApi $solutionPath $secretsScript
}

export def appstart [] {
    startApp $frontendPath
}

export def apistart [] {
    startApi $apiPath { setup }
}
