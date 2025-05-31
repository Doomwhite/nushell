export module example {
    const stsSecretsScript = "setup-user-secrets-stats.ps1"

    export def apistart [] {
        print "apistart"
    }

    export def apistart2 [] {
        apistart 
        print "apistart2"
    }
}

# export module sts-project {
#     # Stats Project Variables
#     const stsSecretsScript = "setup-user-secrets-stats.ps1"
#     const stsSolutionPath = ".\\Stats.sln"
#     const stsFrontendPath = ".\\src\\Movtech.Stats.Presentation.Web"
#     const stsApiPath = ".\\src\\Movtech.Stats.Services.Api"

#     # Stats Project Functions
#     export def stssetup [] {
#         echo "stssetup"
#         copylicense
#         stsmklink
#         stssecrets
#     }

#     export def stsmklink [] {
#         createSymbolicLink $stsApiPath
#     }

#     export def stssecretsopen [] {
#         openSecrets $stsSecretsScript
#     }

#     export def stssecrets [...args: string] {
#         executeSecrets $stsSecretsScript ...$args
#     }

#     export def stsopen [] {
#         openAll $stsSolutionPath $stsFrontendPath $stsSecretsScript
#     }

#     export def stsappopen [] {
#         openFrontend $stsFrontendPath $stsSecretsScript
#     }

#     export def stsapiopen [] {
#         openApi $stsSolutionPath $stsSecretsScript
#     }

#     export def stsappstart [] {
#         startApp $stsFrontendPath
#     }

#     export def stsapistart [] {
#         startApi $stsApiPath { stssetup }
#     }
# }
