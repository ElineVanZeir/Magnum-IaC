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

### install_software 
Deze rol installeert de benodigde software om een openVPN-server te configureren op uw systeem. De taken omvatten:

1. Vereiste pakketten installeren:
- epel-release: Hiermee activeert u de Extra Packages for Enterprise Linux (EPEL) repository, die extra pakketten kan bevatten die niet in de standaard system repository's beschikbaar zijn.
- openvpn: Installeert de OpenVPN-server software.
- easy-rsa: Installeert de Easy-RSA toolkit, die wordt gebruikt voor het genereren van certificaten en sleutels voor OpenVPN.
2. pexpect installeren: Installeert de python3-pexpect Python-bibliotheek. Deze bibliotheek kan handig zijn voor het automatiseren van interacties met commando-regel interfaces (CLI's) tijdens het configureren van OpenVPN.

### Create-certs 
Deze rol voert de volgende taken uit om de Public Key Infrastructure (PKI) voor uw OpenVPN-server te initialiseren en certificaten en sleutels te genereren:

1. PKI initialiseren: Initialiseert de PKI met behulp van de easyrsa init-pki tool.
2. Certificaatautoriteit (CA) bouwen: Bouwt een CA-certificaat met de naam "open_vpn" zonder wachtwoordprompt. De expect module wordt gebruikt om automatisch te reageren op de prompt voor de common name.
3. Diffie-Hellman (DH) parameters genereren: Genereert DH-parameters die worden gebruikt voor perfect forward secrecy (PFS) in OpenVPN.
4. OpenVPN server certificaat bouwen: Bouwt een servercertificaat en sleutel met de naam "open_vpn" zonder wachtwoordprompt. De EASYRSA_BATCH omgeving variabele wordt ingesteld op "yes" om het script in batch-modus uit te voeren.
5. OpenVPN client certificaat bouwen: Bouwt een clientcertificaat en sleutel met de naam "client_open_vpn" zonder wachtwoordprompt. De EASYRSA_BATCH omgeving variabele wordt ingesteld op "yes" om het script in batch-modus uit te voeren.
6. Naar PKI directory navigeren: Navigeert naar de pki directory binnen de Easy-RSA map.
7. Ta key genereren: Genereert een geheim (ta.key) dat wordt gebruikt voor authenticatie tussen de OpenVPN-server en -client.
8. renew_certificates.sh script instellen: Maakt het renew_certificates.sh script uitvoerbaar, zodat het later kan worden gebruikt om certificaten automatisch te vernieuwen.
9. Cronjob toevoegen: Voegt een cronjob toe die elke 3 maanden het renew_certificates.sh script uitvoert. Dit script dient apart geconfigureerd te worden om de certificaten te vernieuwen.

### config-openvpn
deze rol configureert een OpenVPN-server op Red Hat-achtige systemen.

1. Server Configuratie kopiëren: Kopieert het server.conf bestand naar de /etc/openvpn/server directory. Dit bestand bevat de configuratie-instellingen voor de OpenVPN-server.
2. CCD map aanmaken: Maakt een map met de naam ccd in de /etc/openvpn/server directory. De CCD (Client Config Directory) map kan worden gebruikt om client-specifieke configuraties op te slaan.
3. OpenVPN-server starten: Start de OpenVPN-server service en stelt deze in om automatisch te starten bij systeemopstart.

vereisten: 
- Het server.conf bestand moet bestaan en de OpenVPN-server configuratie bevatten.
- De taken in de vorige stap moeten zijn uitgevoerd om certificaten en sleutels te genereren.

### firewalld
Deze rol voert de volgende taken uit:

1. installeren firewalld: Deze taak installeert het firewalld-pakket op het systeem, indien dit nog niet aanwezig is.
2. enable en start firewalld: Deze taak zorgt ervoor dat de firewalld-service wordt gestart en ingeschakeld bij het opstarten van het systeem.
3. allow SSH: Staat SSH-verkeer toe door de SSH-service permanent in te schakelen in firewalld
4. allow OpenVPN: staat verkeer via poort 443/tcp toe, wat vaak wordt gebruikt door OpenVPN.
5. allow semaphore: staat HTTP-verkeer toe via poort 80/tcp voor semaphore. 
6. reload: Deze taak herlaadt de firewalld-configuratie om de aangebrachte wijzigingen door te voeren.

### config-client
Deze rol genereert een OpenVPN client configuratiebestand met de benodigde certificaten en sleutels.
1. Client Configuratie kopiëren: Kopieert het client_config.conf bestand naar de /usr/share/easy-rsa/3/pki directory. Dit bestand kan dienen als basis voor client-specifieke configuraties.
2. ta.key lezen: Leest de inhoud van het ta.key bestand met de shell module.
3. ta.key toevoegen aan client configuratie: Voegt de inhoud van het ta.key bestand toe aan het client_config.conf bestand na de regel "<tls-auth>".
4. ca.crt lezen: Leest de inhoud van het ca.crt bestand met de shell module.
5. ca.crt toevoegen aan client configuratie: Voegt de inhoud van het ca.crt bestand toe aan het client_config.conf bestand na de regel "<ca>".
6. Client certificaat (cert) lezen: Leest de inhoud van het client certificaat (client_open_vpn.crt) met de shell module.
7. Client certificaat toevoegen aan client configuratie: Voegt de inhoud van het client certificaat toe aan het client_config.conf bestand na de regel "<cert>".
8. Client sleutel (key) lezen: Leest de inhoud van de client sleutel (client_open_vpn.key) met de shell module.
9. Client sleutel toevoegen aan client configuratie: Voegt de inhoud van de client sleutel toe aan het client_config.conf bestand na de regel "<key>".
10. Client configuratie ophalen: Haalt het geconfigureerde client_config.conf bestand op van de OpenVPN-server en slaat het op als client_config.ovpn in de lokale directory van de Ansible controller.

Vereisten:

- De taken in de vorige stap moeten zijn uitgevoerd om certificaten en sleutels te genereren.
- Het client_config.conf bestand moet bestaan en de basis client configuratie bevatten. Het ip bij remote moet je op het juiste ip zetten. 

### check 

Deze rol gaat controleren of hele de installatie correct is verlopen. 

1. Controleer OpenVPN installatie:
Deze taak gebruikt de ansible.builtin.stat module om te controleren of het bestand /usr/sbin/openvpn bestaat.
De uitkomst van de controle wordt opgeslagen in de variabele openvpn_installed.
2. Print OpenVPN installatie status:
Deze taak gebruikt de ansible.builtin.debug module om een bericht te printen waarin staat of OpenVPN al dan niet geïnstalleerd is.
De status wordt gebaseerd op de openvpn_installed variabele die door de vorige taak is ingesteld.

## uitvoeren 
Om de code uit te voeren dient men de volgende zaken te doen: 
- Wijzig de host file met het juiste IP
- Zet het ip adres juist in de client config
- En voor het volgende commando uit: 
  `ansible-playbook main.yml`

## Semaphore 
ga in de map van semaphore en voer het commando: 
`docker-compose up -d`

Als alles correct werkt, zou je toegang moeten hebben tot je Semaphore-toepassing via de browser. Ga naar http://localhost:80 om de toepassing te openen. 

### Semaphore UI

1. login met de zelf gekozen admin name en paswoord. 
2. add repository: https://github.com/ElineVanZeir/Magnum-IaC.git
3. add inventory: Hier komen alle ip adressen waar je openVPN op wilt installeren 
  - hiervoor moet je eerst bij 'keystore' zorgen voor de juiste credentials om in te loggen op je machine
4. environment: Hier zijn voorlopig geen variabelen (geef N/A in met {})
5. Template: Hier kan je dan alles linken aan elkaar. 

Je kan dan deze template "runnen" zo hoef je geen commando's meer in te geven en kan je gewoon zo overal openVPN installeren. 

## variabelen
Er is een vault.yml bestand waar eventueel variabelen kunnen worden meegegeven. Deze wordt bij start van de playbook ingeladen. 
 
## Bronnen 
LinuxHelp. (2024, January 27). How to install and configure OpenVPN Server on Rocky Linux 9.2 [Video]. YouTube. https://www.youtube.com/watch?v=I2eK6_PvQcA

ChatGPT. (n.d.). https://chatgpt.com

OpenVPN. (2023, December 15). Business VPN for secure networking | OpenVPN. https://openvpn.net/ 

Retro Mike Tech. (2023, July 3). Ansible Semaphore Installation & Setup | Web UI for Ansible [Video]. YouTube. https://www.youtube.com/watch?v=UCy4Ep2x2q4 

openvpn/sample/sample-config-files/client.conf at master · OpenVPN/openvpn. (n.d.). GitHub. https://github.com/OpenVPN/openvpn/blob/master/sample/sample-config-files/server.conf

openvpn/sample/sample-config-files/client.conf at master · OpenVPN/openvpn. (n.d.). GitHub. https://github.com/OpenVPN/openvpn/blob/master/sample/sample-config-files/client.conf

Installation | Semaphore Docs. (n.d.). https://docs.semui.co/administration-guide/installation#docker 