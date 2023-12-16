# google-script-terraform

## Deploy the resources through Terraform

First, you need to deploy the Terraform resources into the Google Cloud.

It assumes key.json with a valid service principal in the root directory generated for the Google Project linked to a valid subscription with a budget available.

`key.json` should follow the given form:

```
{
  "type": "service_account",
  "project_id": "REAL_VALUE_HERE",
  "private_key_id": "REAL_VALUE_HERE",
  "private_key": "REAL_VALUE_HERE",
  "client_email": "REAL_VALUE_HERE",
  "client_id": "REAL_VALUE_HERE",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "REAL_VALUE_HERE",
  "universe_domain": "googleapis.com"
}

```

It is used then in the `main.tf` for the Terrafom authentication into the Google Cloud:

```
provider "google" {
  credentials = file(var.service_account_file_name)
  project     = var.project_name
  region      = var.deployment_region
}

```

and `var.tf`:

```
variable "service_account_file_name" {
  type        = string
  default     = "key.json"
  description = "name of the service_account auth file"
}
```


Then, to deploy the resources, run the following commands:

1. `terraform init`
```
terraform init   

Initializing the backend...

Initializing provider plugins...
- Reusing previous version of hashicorp/google from the dependency lock file
- Using previously-installed hashicorp/google v5.9.0

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```
2. `terraform validate`
```
terraform validate 
Success! The configuration is valid
```
3. `terraform plan -out tfplan`
```
Plan: 5 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + static_ip = (known after apply)

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Saved the plan to: tfplan

To perform exactly these actions, run the following command to apply:
    terraform apply "tfplan"
```
4. `terraform apply tfplan`
```
Apply complete! Resources: 5 added, 0 changed, 0 destroyed.

Outputs:

static_ip = "34.118.51.202"

```

Now you can adjust the values in `open-tunnel.sh`.


## Log into CLASP Globally

### The script `open-tunnel.sh` is a Bash script designed to create multiple SSH port forwarding tunnels from a local machine to a remote server. 

- Range of Ports: The script sets up SSH port forwarding for ports from 30000 to 47000 in increments of 500.

- Loop Operation: The script uses a for loop to iterate through the specified range. Each iteration sets up port forwarding for a block of 500 ports (or less if it's at the end of the spectrum).

- Port Forwarding: For each block, the script generates a string (port_forwarding) that contains SSH port forwarding options. These options forward ports from the local machine to localhost (i.e., the remote server) in the specified range.

- SSH Connection: The script opens a new gnome-terminal window and runs the SSH command to connect to a virtual machine with the IP *34.118.26.6* **(TO BE REPLACED WITH OUTPUT OF TERRAFORM DEPLOY)** using the specified username *adam* **(TO BE REPLACED WITH YOUR SSH-KEYGEN)** and correlated SSH private key. The generated port forwarding options are included in this SSH command.

- Applicability to Clasp Login: **Logging in to clasp requires a redirect to localhost for authentication.** The script forwards an extensive range of ports to the remote server. If clasp attempts to use any of these ports on your local machine for the redirect, the script will ensure the redirect request is forwarded to the remote server. This approach helps run clasp on a remote server, which needs to authenticate through a web browser on your local machine.

open file edition `open-tunnel.sh` and adjust the steering variables:

```
#!/bin/bash

start=30000 
end=47000 #forwarded port for clasp authentication is always random in such range
increment=500
ssh_username="adam"
ssh_private_key_path="~/.ssh/google-cloud-rsa"
vm_ip="34.118.26.6"
```
Tehn, log into the VM through SSH single time for keys exchange:
`ssh adam@34.118.51.202 -i ~/.ssh/google-cloud-rsa`

Finally, execute script for forwarding ports 30000-47000 into localhost `./open-tunnel.sh`. You should see ~35 opened terminals.

### Login into the clasp


Now, you can log into the clasp globally from one of the opened terminals.

Execute `clasp login`

```
adam@fir-withnextjs-instance:~$ clasp login
Logging in globally…
🔑 Authorize clasp by visiting this url:
https://accounts.google.com/o/oauth2/v2/auth?access_type=offline&scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fscript.deployments%20https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fscript.projects%20https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fscript.webapp.deploy%20https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fdrive.metadata.readonly%20https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fdrive.file%20https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fservice.management%20https%3A%2F%2Fwww.googleapis.com%2Fauth%2Flogging.read%20https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fuserinfo.email%20https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fuserinfo.profile%20https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fcloud-platform&response_type=code&client_id=1072944905499-vm2v2i5dvn0a0d2o4ca36i1vge8cvbn0.apps.googleusercontent.com&redirect_uri=http%3A%2F%2Flocalhost%3A36601
```

Then click the provided URL. It shall authenticate you through the local browser.

```
Authorization successful.

Default credentials saved to: /home/adam/.clasprc.json.
adam@fir-withnextjs-instance:~$ 
```

## Cloning the project

Now begin with creating the new folder.

`mkdir project1 && cd project1`

then clone the desired project
`clasp clone`

```
adam@fir-withnextjs-instance:~/project1$ clasp clone
? Clone which script? maybe                - https://script.google.com/d/1VhXzNY
9G6eLwZI3wWN_2OLvS22HSxD8S62lyualP0SsIljD3KzIxgZqI/edit
Warning: files in subfolder are not accounted for unless you set a '/home/adam/project1/.claspignore' file.
Cloned 2 files.
└─ /home/adam/project1/appsscript.json
└─ /home/adam/project1/Kod.js
Not ignored files:
└─ /home/adam/project1/appsscript.json
└─ /home/adam/project1/Kod.js

Ignored files:
└─ /home/adam/project1/.clasp.json
adam@fir-withnextjs-instance:~/project1$ 
```

## Log into clasp locally

The crucial step now is to log into clasp locally.

To do that, generate OAuth Token in the google cloud console.
It must have the redirect URLs and JS origins set to `http://localhost`
Next, download oAuth token and save it as a `token.json`
Then, open `token.json` in VSCode and format it for nice output

```
{
    "web": {
        "client_id": "REAL_VALUE_HERE",
        "project_id": "REAL_VALUE_HERE",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
        "client_secret": "REAL_VALUE_HERE",
        "redirect_uris": [
            "http://localhost"
        ],
        "javascript_origins": [
            "http://localhost",
        ]
    }
}
```

**THIS FILE IS NOT YET READY FOR THE AUTH WITH CLASP**

Due to not having a fixed clasp library, we must adjust the token for clasp expected form, i.e., change the primary key in the OAuth JSON file from `web` to `installed`:

```
{
    "installed": {
        "client_id": "REAL_VALUE_HERE",
        "project_id": "REAL_VALUE_HERE",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
        "client_secret": "REAL_VALUE_HERE",
        "redirect_uris": [
            "http://localhost"
        ],
        "javascript_origins": [
            "http://localhost",
        ]
    }
}
```

Now, at the ssh terminal with VM, create a new file in the project folder called token.json

`touch token.json && nano token.json`

Paste the entire token.json from the disk manually and save the file with `CTRL + X, Y, ENTER`

Check the content with `cat token.json`

```
adam@fir-withnextjs-instance:~/project1$ touch token.json && nano token.json
adam@fir-withnextjs-instance:~/project1$ cat token.json 
{
    "installed": {
        "client_id": "REAL_VALUE_HERE",
        "project_id": "REAL_VALUE_HERE",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
        "client_secret": "REAL_VALUE_HERE",
        "redirect_uris": [
            "http://localhost"
        ],
        "javascript_origins": [
            "http://localhost",
        ]
    }
}

```

Now we can *directly* log into clasp locally.

`clasp login --creds token.json`

```
Logging in locally…

Authorizing with the following scopes:
https://www.googleapis.com/auth/spreadsheets
https://www.googleapis.com/auth/script.external_request
https://www.googleapis.com/auth/script.webapp.deploy

NOTE: The full list of scopes your project may need can be found at script.google.com under:
File > Project Properties > Scopes

Using credentials located here:
https://console.developers.google.com/apis/credentials?project=fir-withnextjs

🔑 Authorize clasp by visiting this url:
https://accounts.google.com/o/oauth2/v2/auth?access_type=offline&scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fspreadsheets%20https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fscript.external_request%20https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fscript.webapp.deploy&response_type=code&client_id=125613819779-elf0mqj9pao93b3bfelph4dvna4e9hvh.apps.googleusercontent.com&redirect_uri=http%3A%2F%2Flocalhost%3A39593
```

Navigate to the URL and authorize the app.

If it does not work, kill the login process with `CTRL + C` and try again so the different port is chosen for auth randomly.

After the success, you should see the output:


```
Authorization successful.

Local credentials saved to: /home/adam/project1/.clasprc.json.
*Be sure to never commit this file!* It's basically a password.
No access, refresh token, API key or refresh handler callback is set.
```

Now, the final fix is to add the property in `appsscript.json` after cloning the project with `nano appsscript.json`

```
adam@fir-withnextjs-instance:~/project1$ ls
Kod.js  appsscript.json  token.json
adam@fir-withnextjs-instance:~/project1$ nano appsscript.json 
```

In the config JSON, add this :

```
"executionApi": {
        "access": "ANYONE"
    },
```

Save the file and check content with `cat appsscipt.json`

```
adam@fir-withnextjs-instance:~/project1$ cat appsscript.json 
{
    "timeZone": "Europe/Warsaw",
    "dependencies": {
        "libraries": [
            {
                "userSymbol": "GASToolBox",
                "libraryId": "1IzvJ1DGGIw3h41f_e_AdvosnG4UiEqHRPhDd7uw4NvCjf4Pgl01RxjtF",
                "version": "24",
                "developmentMode": false
            }
        ]
    },
    "exceptionLogging": "STACKDRIVER",
    "runtimeVersion": "V8",
    "executionApi": {
        "access": "ANYONE"
    },
    "oauthScopes": [
        "https://www.googleapis.com/auth/spreadsheets",
        "https://www.googleapis.com/auth/script.external_request"
    ]
}
```

Now push the changes with `clasp push` and approve the changes *Manifest file has been updated. Do you want to push and overwrite? (y/N)* click Y, ENTER

```
adam@fir-withnextjs-instance:~/project1$ clasp push
└─ /home/adam/project1/appsscript.json
└─ /home/adam/project1/Kod.js
Pushed 2 files.
```

Now you can deploy your code with `clasp deploy`

```
adam@fir-withnextjs-instance:~/project1$ clasp deploy
Created version 5.
- AKfycbwC6lUKCA5am429KYNFXZY8hMXT0iiRajcc4F7FhzFgxauTryTnLemoooSZKcE1xCdhvA @5.
```

## Running the tests locally

**FIX FOR THE FUTURE RESEARCH**

In theory, you can run functions with `clasp run`. 

However, if the function uses any external scope, then such output is given:

```
adam@fir-withnextjs-instance:~/project1$ clasp run
Running in dev mode.
? Select a functionName myFunction
Error: Permission denied. Be sure that you have:
- Added the necessary scopes needed for the API.
- Enabled the Apps Script API.
- Enable required APIs for project.
```

**FIX FOR THE FUTURE RESEARCH**