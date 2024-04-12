# Contributing to AWS ARC EKS

Thank you for considering contributing to AWS ARC EKS! We appreciate your time and effort.
To ensure a smooth collaboration, please take a moment to review the following guidelines.

## How to Contribute

1. Fork the repository to your own GitHub account.
2. Clone the repository to your local machine.
   ```bash
   git clone https://github.com/<your_organization>/<your_terraform_module>.git
   ```
3. Create a new branch for your feature / bugfix.
   ```bash
   git checkout -b feature/branch_name
   ```
4. Make your changes and commit them.
   ```bash
   git commit -m "Your descriptive commit message"
   ```
5. Push to your forked repository.
   ```bash
   git push origin feature/branch_name
   ```
6. Open a pull request in the original repository with a clear title and description.
   If your pull request addresses an issue, please reference the issue number in the pull request description.

### Git commits

while Contributing or doing git commit please specify the breaking change in your commit message whether its major,minor or patch

For Example

```sh
git commit -m "your commit message #major"
```
By specifying this , it will bump the version and if you don't specify this in your commit message then by default it will consider patch and will bump that accordingly

# Terraform Code Collaboration Guidelines

## File Naming Conventions

1. **Variables File (variables.tf):**
    - All variable names should be in snake_case.
    - Each variable declaration must contain:
        - Description: A brief explanation of the variable's purpose.
        - Type: The data type of the variable.

    Example:
    ```hcl
    variable "example_variable" {
      description = "This is an example variable."
      type        = string
    }
    ```

2. **Outputs File (outputs.tf):**
    - All output names should be in snake_case.
    - Each output declaration must contain:
        - Description: A brief explanation of the output's purpose.
        - Value: The value that will be exposed as the output.

    Example:
    ```hcl
    output "example_output" {
      description = "This is an example output."
      value       = module.example_module.example_attribute
    }
    ```

## Resource and Module Naming

1. **Terraform Resources/Modules:**
    - Resource and module names should be in snake_case.
    - Choose descriptive names that reflect the purpose of the resource or module.

    Example:
    ```hcl
    resource "aws_instance" "web_server" {
      // ...
    }

    module "networking" {
      // ...
    }
    ```

## General Guidelines

1. **Consistent Formatting:**
    - Follow consistent code formatting to enhance readability.
    - Use indentation and line breaks appropriately.

2. **Comments:**
    - Add comments to explain complex logic, decisions, or any non-trivial code.
    - Keep comments up-to-date with the code.

3. **Module Documentation:**
    - Include a README.md file within each module directory, explaining its purpose, inputs, and outputs.
    - Use inline documentation within the code for complex modules.

4. **Avoid Hardcoding:**
    - Minimize hardcoded values; prefer using variables and references for increased flexibility.

5. **Sensitive Information:**
    - Do not hardcode sensitive information (e.g., passwords, API keys). Use appropriate methods for securing sensitive data.

6. **Error Handling:**
    - Implement proper error handling and consider the impact of potential failures.

## Version Control

1. **Commit Messages:**
    - Use descriptive and concise commit messages that explain the purpose of the changes.

2. **Branching:**
    - Follow a branching strategy (e.g., feature branches) for better collaboration.

## Pre-commit Hooks

1. **Install `pre-commit`:**
    - Install `pre-commit` hooks to automatically check and enforce code formatting, linting, and other pre-defined rules before each commit.

    Example:
    ```bash
    brew install pre-commit (for mac users)
    ```
    ```bash
    pre-commit run -a
    ```

    This ensures that your code adheres to the defined standards before being committed, reducing the likelihood of introducing issues into the repository.

## Code Style

Please follow the Terraform language conventions and formatting guidelines. Consider using an editor with Terraform support or a linter to ensure adherence to the style.

## Testing

!!! This section is a work-in-progress, as we are starting to adopt testing using Terratest. !!!

Before submitting a pull request, ensure that your changes pass all tests. If applicable, add new tests to cover your changes.

## Documentation

Keep the module documentation up-to-date.

## Security and Compliance Checks

GitHub Actions are in place to perform security and compliance checks. Please make sure your changes pass these checks before submitting a pull request.

## Licensing

By contributing, you agree that your contributions will be licensed under the project's [LICENSE](LICENSE).
