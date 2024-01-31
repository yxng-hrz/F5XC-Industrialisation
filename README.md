<h1 align="left">F5 XC - Terraform - Template - App-Firewall</h1>

###
<p align="left">

</p>

<p align="left"> Projet : Créer un template de déploiement d'un WAF F5XC.</p>

###

<h2 align="left">Prérequis </h2>

###

<p align="left">Terraform : version 1.6.0 <br>Provider Volterra : version 0.11.26 </p>

###

<h2 align="left"> </h2>

<p align="left">Ici, la capture d'écran montre que dans Accueil/Administration/Gestion personnelle, nous devons créer notre jeton API. <br>À noter : il faut absolument un plan supérieur à gratuit pour pouvoir mettre en place un WAF. </p>

###

<img src="https://github.com/acknowledge-team/F5XC-Industrialisation/tree/main/screenshots/screen001.png?raw=true"><br>


<h2 align="left">Documentation </h2>

###
Documentation pour les providers  - https://registry.terraform.io/providers/volterraedge/volterra/latest/docs <br>
App Delivery Network Module - https://registry.terraform.io/modules/volterraedge/app-delivery-network/volterra/latest <br>
Web App Security Module -     https://registry.terraform.io/modules/volterraedge/web-app-security/volterra/latest <br>

API Documentation :  https://registry.terraform.io/providers/volterraedge/volterra/0.11.26/docs/resources/volterra_app_firewall <br>
Provider source code :  https://github.com/volterraedge/terraform-provider-volterra/blob/main/volterra/resource_auto_volterra_app_firewall.go <br>

###
