terraform {

	backend "s3" {

		bucket				= "my-local-cloud-bucket"
		key				= "terraform.tfstate"
		region				= "us-east-1"
		endpoint			= "http://localhost:4566"
		access_key			= "test"
		secret_key			= "test"
		force_path_style		= true
		skip_credentials_validation	= true
		skip_metadata_api_check		= true
		skip_region_validation		= true
		skip_requesting_account_id	= true
			}

	}

output "environment" {
	value = terraform.workspace
}
