# Magnum-IaC
## OpenVPN
OpenVPN is open source software voor het maken van een virtueel privénetwerk (VPN) waarmee je veilig toegang kunt krijgen tot beschermde netwerkbronnen en op het internet kunt surfen. Het wordt gebruikt om veilige point-to-point versleutelde tunnels te maken tussen twee computers over een onveilig netwerk.

## Roles 
### Updateall 
Deze rol gata ervoor zorgen dat eerst je machine geupdated wordt. Dit voorkomt moeilijkheden bij het downloaden en installeren van openVPN. 

### Firewalld
Deze rol gaat zorgen dat je machine om te beginnen een firewall heeft. Er wordt dan voor gezorgd dat deze altijd aanstaat, je hoeft die dus niet elke keer aan te zetten bij het opstarten van de machine. De nodige poorten worden dan opengezet en als de rest blijft gesloten kwestie van veiligheid. 

### install software
Deze rol gaat de nodige software installeren voor openVPN. 

## Bronnen 
LinuxHelp. (2024, January 27). How to install and configure OpenVPN Server on Rocky Linux 9.2 [Video]. YouTube. https://www.youtube.com/watch?v=I2eK6_PvQcA

