### Purpose of the Document

This document provides guidelines and instructions for users looking to connect with opensearch dashboard using AWS Client VPN.

### What is AWS Client VPN ?
AWS Client VPN is a managed remote access VPN solution used by your remote workforce to securely access resources within both AWS and your on-premises network. Fully elastic, it automatically scales up, or down, based on demand.

### How to create AWS Client VPN file and VPN Client Connection
- Download and install AWS Client VPN Application [download](https://aws.amazon.com/vpn/client-vpn-download/)
- Download the AWS Client VPN Configuration File
	- Navigate to `VPC` > `Client VPN endpoints`
	- Select the endpoint and click `Download Client Configuration`
- Incase authentication is using certificate
	- Open the Client Configuration file in an editor.
	- Append the certificate data as show below to the configuration file and save the file
	```
	<cert>
		Copy from SSM PARAMETER STORE self-signed-cert-ca.pem
	</cert>

	<key>
		Copy from SSM PARAMETER STORE self-signed-cert-ca.key
	</key>
	```
- Open AWS VPN Client on your system
    - Navigate to `File` > `Manage Profiles` 
    - Click on `Add Profile` 
    - Provide the `Display Name` and Upload the VPN Configuration file
    - Now, select the `Profile` and click on connect


### Access OpenSearch Dashboard

- Copy the Opensearch domain endpoint from AWS Opensearch console and open in browser
- User Opensearch user name and password saved in SSM Parameter Store
