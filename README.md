# terraform-init-envs

Terraform module to create the (Opinionated) directory structure for a project and create the backends to store the Terraform state and lock.


## Usage

Start up the [utilities](utilities/docker-image-bins/) docker image (which has already a section to properly configure your secrets), move into the "examples" (Or any other) directory and create a "terraform.tfvars" using "terraform.tfvars.example" as an example. The contents should be like:

```bash
list_environments       = ["dev","test","prod"]
s3_dyn_name             = "awesome-name"
bucket_sse_algorithm    = "AES256"
region                  = "eu-east-1"
```

We favour the usage of ".tfvars" files and it's reflected in the code.

After you are done with this, issue the following command where the previous files are:

```bash
cd backend-init-envs/
terraform init
terraform apply
```

The directory structure we follow is something like this:
```bash
tree -d
    .
    ├── backend-init-envs
    ├── dev
    └── test

```

The module will create buckets to store Terraform's remote configuration of each environment. Obviously, the state that is used to create those buckets is **local**.
You should have a folder with separated directories for each defined area, and a bucket for each environment, with prepopulated configurations that will store the remote state of each environment in the buckets created to do so.

Once you want to initialize any of the environments, traverse to it's folder and do the following commands:
```bash
cd ../dev
terraform init -backend-config backend.tfvars
terraform apply
```

## TODO
- Make it work with GCP
- Complete utilities
- Copy utilities on module invokation
- DynamoDB region placement
- Reference versions using parameter for files creation