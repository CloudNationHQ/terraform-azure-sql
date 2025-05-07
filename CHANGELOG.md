# Changelog

## [2.0.0](https://github.com/CloudNationHQ/terraform-azure-sql/compare/v1.5.0...v2.0.0) (2025-05-07)


### ⚠ BREAKING CHANGES

* The data structure changed, causing a recreate on existing resources.

### Features

* add type definitions and small refactor ([#73](https://github.com/CloudNationHQ/terraform-azure-sql/issues/73)) ([7a21e2f](https://github.com/CloudNationHQ/terraform-azure-sql/commit/7a21e2f77bd7c3958b9611d8eb49c65d375563e5))

## [1.5.0](https://github.com/CloudNationHQ/terraform-azure-sql/compare/v1.4.0...v1.5.0) (2025-04-10)


### Features

* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#65](https://github.com/CloudNationHQ/terraform-azure-sql/issues/65)) ([1ae4970](https://github.com/CloudNationHQ/terraform-azure-sql/commit/1ae4970d2f06f546af451ba8fa00869abbdbbc09))
* **deps:** bump golang.org/x/net from 0.33.0 to 0.36.0 in /tests ([#66](https://github.com/CloudNationHQ/terraform-azure-sql/issues/66)) ([e8a0acf](https://github.com/CloudNationHQ/terraform-azure-sql/commit/e8a0acfc2a97ca9aed64fefd11807d16c7b2a8d0))


### Bug Fixes

* update documentation ([#70](https://github.com/CloudNationHQ/terraform-azure-sql/issues/70)) ([8a27c40](https://github.com/CloudNationHQ/terraform-azure-sql/commit/8a27c40e65dbcdbf5b6cd12acc58a922b76a0b9d))

## [1.4.0](https://github.com/CloudNationHQ/terraform-azure-sql/compare/v1.3.0...v1.4.0) (2025-04-09)


### Features

* add schema validation items for sql ([#67](https://github.com/CloudNationHQ/terraform-azure-sql/issues/67)) ([431cf86](https://github.com/CloudNationHQ/terraform-azure-sql/commit/431cf869bf5e55f91d51756ed360649537b4931d))

## [1.3.0](https://github.com/CloudNationHQ/terraform-azure-sql/compare/v1.2.0...v1.3.0) (2025-01-20)


### Features

* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#59](https://github.com/CloudNationHQ/terraform-azure-sql/issues/59)) ([d594a52](https://github.com/CloudNationHQ/terraform-azure-sql/commit/d594a52a4ae888a18cdf62074c44d628f93fef92))
* **deps:** bump golang.org/x/crypto from 0.29.0 to 0.31.0 in /tests ([#62](https://github.com/CloudNationHQ/terraform-azure-sql/issues/62)) ([4c72a54](https://github.com/CloudNationHQ/terraform-azure-sql/commit/4c72a548dff1971db48ed05199db7acb71658e7f))
* **deps:** bump golang.org/x/net from 0.31.0 to 0.33.0 in /tests ([#63](https://github.com/CloudNationHQ/terraform-azure-sql/issues/63)) ([6b2442b](https://github.com/CloudNationHQ/terraform-azure-sql/commit/6b2442bc90102555063379ca5daefe70c5586da4))
* remove temporary files when deployment tests fails ([#60](https://github.com/CloudNationHQ/terraform-azure-sql/issues/60)) ([a2320bc](https://github.com/CloudNationHQ/terraform-azure-sql/commit/a2320bc7e1091e12a5a59eadbbecf3560017fdc2))

## [1.2.0](https://github.com/CloudNationHQ/terraform-azure-sql/compare/v1.1.0...v1.2.0) (2024-11-11)


### Features

* enhance testing with sequential, parallel modes and flags for exceptions and skip-destroy ([#56](https://github.com/CloudNationHQ/terraform-azure-sql/issues/56)) ([a60236b](https://github.com/CloudNationHQ/terraform-azure-sql/commit/a60236b4893443c7a53022766d1945f4fcb6f2dd))

## [1.1.0](https://github.com/CloudNationHQ/terraform-azure-sql/compare/v1.0.0...v1.1.0) (2024-10-18)


### Features

* added primary assigned identity attribute ([#55](https://github.com/CloudNationHQ/terraform-azure-sql/issues/55)) ([d8d1196](https://github.com/CloudNationHQ/terraform-azure-sql/commit/d8d1196c9b9194ba4883eb3c90f229d3fae03182))
* auto generated docs and refine makefile ([#53](https://github.com/CloudNationHQ/terraform-azure-sql/issues/53)) ([2935c55](https://github.com/CloudNationHQ/terraform-azure-sql/commit/2935c55a8c0201b6ba88a9c49690af44b2aabf16))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#52](https://github.com/CloudNationHQ/terraform-azure-sql/issues/52)) ([ce7c800](https://github.com/CloudNationHQ/terraform-azure-sql/commit/ce7c80081c423c25bf56cdefc1b491ab742bd681))

## [1.0.0](https://github.com/CloudNationHQ/terraform-azure-sql/compare/v0.10.0...v1.0.0) (2024-09-25)


### ⚠ BREAKING CHANGES

* Version 4 of the azurerm provider includes breaking changes.

### Features

* upgrade azurerm provider to v4 ([#50](https://github.com/CloudNationHQ/terraform-azure-sql/issues/50)) ([92fa56b](https://github.com/CloudNationHQ/terraform-azure-sql/commit/92fa56ba6aebb67f038f186190689c1f75ea861e))

### Upgrade from v0.10.0 to v1.0.0:

- Update module reference to: `version = "~> 1.0"`
- Change properties in instance object:
  - resourcegroup -> resource_group
  - immutable_backups_enabled -> deprecated
- Rename variable:
  - resourcegroup -> resource_group

## [0.10.0](https://github.com/CloudNationHQ/terraform-azure-sql/compare/v0.9.0...v0.10.0) (2024-08-29)


### Features

* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#46](https://github.com/CloudNationHQ/terraform-azure-sql/issues/46)) ([9e1f0bd](https://github.com/CloudNationHQ/terraform-azure-sql/commit/9e1f0bd790513643275951775fe439e501cc82c8))
* update documentation ([#47](https://github.com/CloudNationHQ/terraform-azure-sql/issues/47)) ([ab6f95a](https://github.com/CloudNationHQ/terraform-azure-sql/commit/ab6f95a3ca351026912bfb357da1947f4627f443))

## [0.9.0](https://github.com/CloudNationHQ/terraform-azure-sql/compare/v0.8.0...v0.9.0) (2024-07-04)


### Features

* add issue templates ([#38](https://github.com/CloudNationHQ/terraform-azure-sql/issues/38)) ([07ea121](https://github.com/CloudNationHQ/terraform-azure-sql/commit/07ea12134bfac05793acb8075b1b48a6ed9323b2))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#44](https://github.com/CloudNationHQ/terraform-azure-sql/issues/44)) ([4d6c140](https://github.com/CloudNationHQ/terraform-azure-sql/commit/4d6c140008068b07da7968ba59a19ad21d54d029))
* **deps:** bump github.com/hashicorp/go-getter in /tests ([#37](https://github.com/CloudNationHQ/terraform-azure-sql/issues/37)) ([a83a9ab](https://github.com/CloudNationHQ/terraform-azure-sql/commit/a83a9abe91c9158369fbcd13b760307ecbfe4bca))
* update contribution docs ([e9dba76](https://github.com/CloudNationHQ/terraform-azure-sql/commit/e9dba76128966533dd4d2ebe9e8d7f043dfdcc85))


### Bug Fixes

* adjust issue template ([#40](https://github.com/CloudNationHQ/terraform-azure-sql/issues/40)) ([a72519f](https://github.com/CloudNationHQ/terraform-azure-sql/commit/a72519f06b7a48693f1a504397ebeb30a64aea36))

## [0.8.0](https://github.com/CloudNationHQ/terraform-azure-sql/compare/v0.7.0...v0.8.0) (2024-06-07)


### Features

* add pull request template ([#35](https://github.com/CloudNationHQ/terraform-azure-sql/issues/35)) ([230e644](https://github.com/CloudNationHQ/terraform-azure-sql/commit/230e644a741c3e5076035cccf067dedd1f0826bb))

## [0.7.0](https://github.com/CloudNationHQ/terraform-azure-sql/compare/v0.6.0...v0.7.0) (2024-05-31)


### Features

* add long and short term retention policy support for databases ([#33](https://github.com/CloudNationHQ/terraform-azure-sql/issues/33)) ([ef27297](https://github.com/CloudNationHQ/terraform-azure-sql/commit/ef27297df21cfecf75d6e0fcdf2a0cb4f126a287))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#32](https://github.com/CloudNationHQ/terraform-azure-sql/issues/32)) ([12e6797](https://github.com/CloudNationHQ/terraform-azure-sql/commit/12e6797ac3eb69517534e6e08dcd79c5b51846c2))
* **deps:** bump github.com/hashicorp/go-getter in /tests ([#29](https://github.com/CloudNationHQ/terraform-azure-sql/issues/29)) ([c0e97f9](https://github.com/CloudNationHQ/terraform-azure-sql/commit/c0e97f90aa9fd929e24549d60381f871054bbd76))
* **deps:** bump golang.org/x/net from 0.17.0 to 0.23.0 in /tests ([#28](https://github.com/CloudNationHQ/terraform-azure-sql/issues/28)) ([b84505d](https://github.com/CloudNationHQ/terraform-azure-sql/commit/b84505de05b9955f200fc22b2c172825f2e4a963))

## [0.6.0](https://github.com/CloudNationHQ/terraform-azure-sql/compare/v0.5.0...v0.6.0) (2024-03-15)


### Features

* add private endpoint usage ([#25](https://github.com/CloudNationHQ/terraform-azure-sql/issues/25)) ([d236a71](https://github.com/CloudNationHQ/terraform-azure-sql/commit/d236a71f29d17810e20b6459aa44ef1730521458))
* **deps:** bump google.golang.org/protobuf in /tests ([#24](https://github.com/CloudNationHQ/terraform-azure-sql/issues/24)) ([d2d9aaf](https://github.com/CloudNationHQ/terraform-azure-sql/commit/d2d9aafc2b156efd9f4fc3b3d1784d9653e62b7b))

## [0.5.0](https://github.com/CloudNationHQ/terraform-azure-sql/compare/v0.4.1...v0.5.0) (2024-03-06)


### Features

* optimized dynamic identity blocks ([#22](https://github.com/CloudNationHQ/terraform-azure-sql/issues/22)) ([647a174](https://github.com/CloudNationHQ/terraform-azure-sql/commit/647a174b2f4d183f137389a64fbde681cc9ac1d3))

## [0.4.1](https://github.com/CloudNationHQ/terraform-azure-sql/compare/v0.4.0...v0.4.1) (2024-03-06)


### Bug Fixes

* fixed duplication in database creation with elastic pool assignment ([#20](https://github.com/CloudNationHQ/terraform-azure-sql/issues/20)) ([b919899](https://github.com/CloudNationHQ/terraform-azure-sql/commit/b9198992cc4f315a709cb4f8d572f7463b9bf521))

## [0.4.0](https://github.com/CloudNationHQ/terraform-azure-sql/compare/v0.3.0...v0.4.0) (2024-03-06)


### Features

* add some missing properties ([#18](https://github.com/CloudNationHQ/terraform-azure-sql/issues/18)) ([05c5b70](https://github.com/CloudNationHQ/terraform-azure-sql/commit/05c5b708c7e76a3c48f5d7a2a72752b007b35830))

## [0.3.0](https://github.com/CloudNationHQ/terraform-azure-sql/compare/v0.2.0...v0.3.0) (2024-01-23)


### Features

* add several missing properties ([#17](https://github.com/CloudNationHQ/terraform-azure-sql/issues/17)) ([6978dd7](https://github.com/CloudNationHQ/terraform-azure-sql/commit/6978dd718ca632b6a3b3230b80598274d5113ac0))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#15](https://github.com/CloudNationHQ/terraform-azure-sql/issues/15)) ([13982db](https://github.com/CloudNationHQ/terraform-azure-sql/commit/13982db8a757f4418b8c7db438142102d6ede026))

## [0.2.0](https://github.com/CloudNationHQ/terraform-azure-sql/compare/v0.1.1...v0.2.0) (2024-01-18)


### Features

* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#10](https://github.com/CloudNationHQ/terraform-azure-sql/issues/10)) ([568a64b](https://github.com/CloudNationHQ/terraform-azure-sql/commit/568a64b97ff1f480693aabd5fccb0a64118e998b))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#13](https://github.com/CloudNationHQ/terraform-azure-sql/issues/13)) ([fd53fbe](https://github.com/CloudNationHQ/terraform-azure-sql/commit/fd53fbe85abc925884143021a2da530d54991c92))
* **deps:** bump golang.org/x/crypto from 0.14.0 to 0.17.0 in /tests ([#11](https://github.com/CloudNationHQ/terraform-azure-sql/issues/11)) ([fb5ee33](https://github.com/CloudNationHQ/terraform-azure-sql/commit/fb5ee3365d7ce837074d589af377fc8c79b54d02))
* small refactor workflows ([a775cfe](https://github.com/CloudNationHQ/terraform-azure-sql/commit/a775cfec2749d2c4a7a049af452ba196049435a7))
* trigger workflow ([729e48c](https://github.com/CloudNationHQ/terraform-azure-sql/commit/729e48c3f17230b6a45fa0a4204e92eb299aa804))

## [0.1.1](https://github.com/CloudNationHQ/terraform-azure-sql/compare/v0.1.0...v0.1.1) (2023-12-04)


### Bug Fixes

* change default username ([#5](https://github.com/CloudNationHQ/terraform-azure-sql/issues/5)) ([c4215f5](https://github.com/CloudNationHQ/terraform-azure-sql/commit/c4215f5253b7f208971f9009f7a30f0aa21cd3b7))

## 0.1.0 (2023-12-01)


### Features

* add initial resources ([#1](https://github.com/CloudNationHQ/terraform-azure-sql/issues/1)) ([96b9d76](https://github.com/CloudNationHQ/terraform-azure-sql/commit/96b9d7679b06546da5bd44307d603268b25adb50))
