# Terraform Enterprise API Client & Command Line Tool
A simple Ruby API client library and command line tool for the [Terraform Enterprise API](https://www.terraform.io/docs/enterprise/api/index.html).



## Requirements

MRI Ruby 2.0 and newer are supported. Alternative interpreters compatible with 2.0+ should work as well.

Earlier Ruby versions such as 1.8.7, 1.9.2, and 1.9.3 may work but are not supported.

This gem depends on these other gems for usage at runtime:

- [rest-client](https://github.com/rest-client/rest-client)
- [colorize](https://github.com/fazibear/colorize)
- [thor](https://github.com/erikhuda/thor)

## API Client

### Usage



#### Basic Example

```ruby
require 'terraform-enterprise-client'

api_key = ENV['TERRAFORM_ENTERPRISE_TOKEN']
client = TerraformEnterprise::Client.new(api_key: api_key)

# Create a new organization
org = client.organizations.create(name:'my-org',email:'maciej@skierkowski.com')

# Create a new workspace in the new organization.
# Uses the same parameters as the following docs:
# https://www.terraform.io/docs/enterprise/api/workspaces.html
client.workspaces.create(name:'my-new-workspace', organization:'my-org')

# Delete the workspace
client.workspaces.delete(name:'my-new-workspace', organization: 'my-org')

# Delete the organization now that we are done
client.organizations.delete(name:'my-org')
```



### Configuration

There are two main settings that can be modified on initialization:

- `:api_key` (required) - which specifies the API key (formerly called ATLAS_TOKEN)
- `:host` - a hostname other than the default (`app.terraform.io`) for usage with private installs

### Resources

The number of supported resources is a subset of the resources exposed via the Terraform Enterprise API. Additional resources will be added in future releases. Current supported resources include:

- `Client#workspaces`
- `Client#organizations`
- `Client#oauth_tokens`

## Command Line Tool

Installing the gem installs the `tfe` command line tool. Running `tfe help` provides the help information and list of available subcomands.

### Usage

All of the resources, actions and paraeters are documented in the tool and available through the `help` subcommand.

#### Basic Usage
```shell
➭ tfe help
Commands:
  tfe help [COMMAND]              # Describe available commands or one specific command
  tfe oauth_tokens <subcommand>   # Manage OAuth tokens
  tfe organizations <subcommand>  # Manage organizations
  tfe workspaces <subcommand>     # Manage workspaces
```

### Scripting
The CLI is designed to be easy to call from other scripts. A few command line options exist to control the output format to minimize the string parsing needed to extract the desired data from the output:

- `no-color` (Boolean, default: false): Removes ANSI color codes from output
- `except` (Array): Exclude particular fields from the output from being returned. This is a space-separated list of fields to be excluded from the output.
- `only` (Array): Only return the fields selected in this space-separated list of field keys.
- `all` (Boolean, default: false): By default most commands only return a subset of fields. Many of the APIs return additional attributes which are used by the UI and likely have little value to you. As such, they are excluded by default. This option will return all of the fields, not just the subset.
- `value` (Boolean, default: false): The output text by default shows the key and values for each field. If this option is enabled only the value of the fields will be returned. This is particularly useful if you would like to obtain the id of a newly created resource (e.g. `tfe workspcaces create new-ws --organization my-organization --only name --value` would return only the name of the created workspace)
