# Magnum-IaC
## OpenVPN
OpenVPN is open source software voor het maken van een virtueel privénetwerk (VPN) waarmee je veilig toegang kunt krijgen tot beschermde netwerkbronnen en op het internet kunt surfen. Het wordt gebruikt om veilige point-to-point versleutelde tunnels te maken tussen twee computers over een onveilig netwerk.

## Roles 
### Updateall 
Deze rol voert de volgende taken uit:

1. Alle pakketten bijwerken: Het updatet alle pakketten op uw systeem naar de nieuwste versie.
2. Pakkettencache bijwerken: Voordat pakketten worden bijgewerkt, wordt de cache bijgewerkt om te ensuren dat er naar de meest recente pakketlijsten wordt verwezen.
3. dnf-automatic installeren: De rol installeert de dnf-automatic-pakket, waarmee automatische updates op uw systeem kunnen worden geconfigureerd.
4. Automatische update timer inschakelen: De rol schakelt de timer voor dnf-automatic in, zodat uw systeem op regelmatige basis automatisch wordt bijgewerkt.

### ufwinstall
Deze rol voert de volgende taken uit:

1. Alle pakketten bijwerken: De rol gebruikt dnf om alle pakketten op uw systeem naar de nieuwste versie te upgraden.
2. UFW installeren: De rol installeert de ufw-pakket, waarmee u een firewall op uw systeem kunt configureren.
3. UFW service activeren: De rol activeert de ufw-service, zodat de firewall direct operationeel is.
4. SSH toestaan: Opent poort 22 (TCP) voor inkomende SSH-verbindingen.
5. OpenVPN toestaan: Opent poort 443 (TCP) voor inkomende OpenVPN-verbindingen.

### install-docker-rocky
Deze rol voert de volgende taken uit:

1. Docker repository toevoegen: De rol voegt de Docker repository toe aan uw systeem, zodat u Docker-pakketten kunt installeren.
2. Docker pakketten installeren: De rol installeert de benodigde Docker-pakketten, waaronder docker-ce, docker-ce-cli, containerd.io en docker-compose-plugin.
3. Gebruiker toevoegen aan Docker groep: De rol voegt de gebruiker gedefinieerd door de variabele docker_user toe aan de docker-groep. Deze gebruiker kan dan Docker-commando's uitvoeren zonder root-toegang.
4. Docker service starten: De rol start de Docker-service en stelt deze in om automatisch te starten bij systeemopstart.
5. Installatie verifiëren: De rol gebruikt de docker_container module om een testcontainer met de naam HelloWorld te starten. Dit controleert of Docker correct is geïnstalleerd en functioneert.

Vereisten:

De variabele docker_user moet worden gedefinieerd in vault.yml om de gebruiker aan te duiden die aan de Docker-groep wordt toegevoegd.

### install software
Deze rol gaat de nodige software installeren voor openVPN. 

## Bronnen 
LinuxHelp. (2024, January 27). How to install and configure OpenVPN Server on Rocky Linux 9.2 [Video]. YouTube. https://www.youtube.com/watch?v=I2eK6_PvQcA

