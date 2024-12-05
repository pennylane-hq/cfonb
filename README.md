# CFONB Parser

This parser aim at simplifying the parsing of CFONB structured files.
Which are files structured with either 120 or 240 characters lines containing mostly bank statements.
We aimed here only at the 120 characters version.

What CFONB means ? `Comité Français d’Organisation et de Normalisation Bancaire`

- Original Document in French 🇫🇷 (from July 2004)
  [20130612113947_7_4_Releve_de_Compte_sur_support_informatique_2004_07.pdf](https://github.com/pennylane-hq/cfonb/files/13307686/20130612113947_7_4_Releve_de_Compte_sur_support_informatique_2004_07.pdf)
- Updated Operation details codes (from August 2007)
  [Evolutions du Relevé de Compte 120 caractères pour les opérations de virement_2007_08.pdf](https://github.com/user-attachments/files/17554987/Evolutions.du.Releve.de.Compte.120.caracteres.pour.les.operations.de.virement.Aout.2007.pdf)

## Requirements

None.

## Installation

```bash
gem install cfonb
```

Or, put it in your Gemfile:

```ruby
gem 'cfonb'
```

## Available Operation Details

`OperationDetails` are lines starting with `05`. They aim at providing additional information about the operation.
Below is the list of additional details available for each operation.

These details can be accessed through `operation.details`, which will provide all the attributes. To fetch a specific attribute, you can use `operation.details.attribute`. For example, `operation.details.unstructured_label`. Ultimately, you can also access the 70 characters of the detail by using its code like `operation.details.mmo`.

All unmapped details can be accessed via `details.unknown` which are stored in a hash with the format `'detail_code' => 'line_detail'`, so
to get the data for the unknown detail_code `AAA` the call would be `details.unknown['AAA']`.

Object example:

```
#<CFONB::Details:0x0000
 @AAA="UNKNOWN DETAIL INFO",
 @LIB="MENSUEAUHTR12345",
 @NPY="INTERNET SFR",
 @RCN="OTHER REFERENCE                    PURPOSE",
 @REF="REFERENCE",
 @client_reference="OTHER REFERENCE",
 @debtor="INTERNET SFR",
 @free_label="MENSUEAUHTR12345",
 @operation_reference="REFERENCE",
 @purpose="PURPOSE",
 @unknown={"AAA"=>"UNKNOWN DETAIL INFO"}
>
```

If you encounter new and relevant ones, please open an issue or a pull request with the appropriate implementation.
We aimed at making it as easy as possible to add new details. You just need to do the following on initialization:

```ruby
CFONB::OperationDetails.register('FEE', self)
```

| Detail Code | Attributes                                              | Description                                                                                                                                 |
| ----------- | ------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| FEE         | `fee`, `fee_currency`                                   | Represents operation fees the bank is applying                                                                                              |
| IPY         | `debtor_identifier`, `debtor_identifier_type`           | Debtor identifier and debtor identifier type                                                                                                |
| IBE         | `creditor_identifier`, `creditor_identifier_type`       | Creditor identifier and the type of identifier                                                                                              |
| LC2         | `unstructured_label_2`                                  | Not structured label line 2 (last 70 characters)                                                                                            |
| LCC         | `unstructured_label`                                    | Not structured label line 1 (first 70 characters)                                                                                           |
| LCS         | `structured_label`                                      | Structured label                                                                                                                            |
| LIB         | `free_label`                                            | Free label                                                                                                                                  |
| MMO         | `original_currency`, `original_amount`, `exchange_rate` | Amount and currency if it has been converted from a foreign currency. The `original_amount` is unsigned, meaning it is always non-negative. |
| NBE         | `creditor`                                              | Name of the creditor or beneficiary                                                                                                         |
| NBU         | `ultimate_creditor`                                     | Name of the ultimate creditor or payer                                                                                                      |
| NPO         | `ultimate_debtor`                                       | Name of the ultimate debtor or beneficiary                                                                                                  |
| NPY         | `debtor`                                                | Name of the debtor or payer                                                                                                                 |
| RCN         | `client_reference`, `purpose`                           | Client reference and Payment nature/purpose                                                                                                 |
| REF         | `operation_reference`                                   | Bank operation reference                                                                                                                    |

## Usage

```ruby
require 'cfonb'

# Parse a file
text = File.open('spec/files/example.txt')
cfonb = CFONB.parse(text)
```

## Contributing

Bug reports and pull requests are welcome on GitHub.
