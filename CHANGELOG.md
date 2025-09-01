# Changelog

## [0.3.0](https://www.github.com/clinical-genomics-uppsala/fada/compare/v0.2.0...v0.3.0) (2025-09-01)


### Features

* keep reads marked as duplicates in the bam file ([efeca96](https://www.github.com/clinical-genomics-uppsala/fada/commit/efeca969312bf7cd34a452837c4ba6c01cca45af))
* remove pbsv from twist cancer pipeline ([aae3393](https://www.github.com/clinical-genomics-uppsala/fada/commit/aae3393b6f2a9f4a72557a70b82415652843aa72))
* update cnv_sv module ([5163dba](https://www.github.com/clinical-genomics-uppsala/fada/commit/5163dbaf324de23a181d377292445da186a6fbdf))
* update deepvariant to v1.9.0 ([2335c9e](https://www.github.com/clinical-genomics-uppsala/fada/commit/2335c9e5f55dfaf29389cec259ae6ac2725c2d60))
* use design_bed for hs_metrics ([6f6e6c1](https://www.github.com/clinical-genomics-uppsala/fada/commit/6f6e6c18c04001c6c1cb6ffc72b5ab91f7a4bb9e))


### Bug Fixes

* update handling of configs to skip in snv indel calling ([b8352dd](https://www.github.com/clinical-genomics-uppsala/fada/commit/b8352dd8b3609d7ae4703715a58520bba20998b7))

## [0.2.0](https://www.github.com/clinical-genomics-uppsala/fada/compare/v0.1.0...v0.2.0) (2025-08-30)


### Features

* report hs metrics for the gene regions in the design and not the pgrs targets ([4ddefb2](https://www.github.com/clinical-genomics-uppsala/fada/commit/4ddefb2a63f7dc9c183bfc4942ca45d90a0abe90))
* update all hydra-genetics module versions ([a81a70e](https://www.github.com/clinical-genomics-uppsala/fada/commit/a81a70e8c7edc3d5b0332ef38c3c54e31ca2a11d))
* update hydra-genetics modules ([45775e4](https://www.github.com/clinical-genomics-uppsala/fada/commit/45775e47021dccc584045b7902c9185afe010557))
* update module versions ([11eba0c](https://www.github.com/clinical-genomics-uppsala/fada/commit/11eba0cd54afa365648d848dea2302f20977eacf))
* update reference fasta to the giab v3 ref ([135c52c](https://www.github.com/clinical-genomics-uppsala/fada/commit/135c52ced7e4c615394930b17f815975e7ea45dd))
* update sawfish to sawfish2, and update sniffles version ([0701ec7](https://www.github.com/clinical-genomics-uppsala/fada/commit/0701ec746b636328b90439e6bbcc69db5f89a784))
* update to sawfish 2 ([b6f68d4](https://www.github.com/clinical-genomics-uppsala/fada/commit/b6f68d4d39a6596d03ab70f3f62eb86ffc7cfaab))
* update wgs workflow to keep the tests happy ([a1399bf](https://www.github.com/clinical-genomics-uppsala/fada/commit/a1399bf5253694c8d44c49f5431b545291cd9768))


### Bug Fixes

* add sample-id to sniffles vcf ([a4ab36b](https://www.github.com/clinical-genomics-uppsala/fada/commit/a4ab36b52f77449eefe12c210b4e8101568d986c))
* paraphase jsom copy ([6750d66](https://www.github.com/clinical-genomics-uppsala/fada/commit/6750d66e309908245eb8f64a3b3f9ff8850c3768))


### Documentation

* change pipeline name for mkdocs ([178f221](https://www.github.com/clinical-genomics-uppsala/fada/commit/178f221a7fe53b7d943f3d12d63a6fb99a5c5c71))
* update message on samtools view rule ([e59b1b9](https://www.github.com/clinical-genomics-uppsala/fada/commit/e59b1b96e8c5896c98b1116e31eded239d38760b))

## 0.1.0 (2025-03-28)


### Features

* add alignment and compression ([729ceaf](https://www.github.com/clinical-genomics-uppsala/fada/commit/729ceafd775453a8d8bc8befc933c08abf2038cb))
* add coverage report scripts ([bbb82d2](https://www.github.com/clinical-genomics-uppsala/fada/commit/bbb82d2c31a25208cd27ddf93923bb9fe3c8e6d5))
* add deepvariant and trgt ([0fe1b4a](https://www.github.com/clinical-genomics-uppsala/fada/commit/0fe1b4a241941eb49a364795da2c41cf72e612a0))
* add filtering module ([990207d](https://www.github.com/clinical-genomics-uppsala/fada/commit/990207df2fa80a9768c91af207df9875fbd8ebb6))
* add mapping, target qc for ont targeted ([47187ec](https://www.github.com/clinical-genomics-uppsala/fada/commit/47187ec3e4cc45625ee238ba1c9ffa17ac999644))
* add ont str worklow ([df195bc](https://www.github.com/clinical-genomics-uppsala/fada/commit/df195bc79037c710f65e896e0b246fc27be8044c))
* add pacbio twist cancer pipeline ([dc9a652](https://www.github.com/clinical-genomics-uppsala/fada/commit/dc9a65208bc5ecf8c8c286e7fc974d04f7ad67d1))
* add reference version to vcf headers ([5803c57](https://www.github.com/clinical-genomics-uppsala/fada/commit/5803c57eb7cc665634b21acbc9399fcec61c2b65))
* add rules and scripts for excel coverage report ([6c0e81e](https://www.github.com/clinical-genomics-uppsala/fada/commit/6c0e81e93b8f64fb59af1522623a4c602831096e))
* add script to calculate basic read metrics ([ecca99a](https://www.github.com/clinical-genomics-uppsala/fada/commit/ecca99ac197af1720b52b61e931f86ad6ea98a0f))
* add separare ont and pacbio configs ([af73f15](https://www.github.com/clinical-genomics-uppsala/fada/commit/af73f15f704dc3558d6332cc75fbcd793e020919))
* add sniffles2 and trgt plot ([7b268f7](https://www.github.com/clinical-genomics-uppsala/fada/commit/7b268f79d0d1524d32245e6d0dfe4d8fcfbe8735))
* add sniffles2 mosaic calling to tc workflow ([d501569](https://www.github.com/clinical-genomics-uppsala/fada/commit/d501569b8c41dd07416f53fba07486b4da8200e4))
* add strkit and strdust callers ([eedc711](https://www.github.com/clinical-genomics-uppsala/fada/commit/eedc711083278153447f5d3c612925f62dbf8031))
* update min snakemake and hydra versions ([178cf60](https://www.github.com/clinical-genomics-uppsala/fada/commit/178cf602a8117d9fb5887dd1be0a7814fe7f7821))
* update paraphase for targeted data ([5fa4272](https://www.github.com/clinical-genomics-uppsala/fada/commit/5fa42722f9697617ca7876beeb18900dc24fa401))
* update snv indels module ([f719c2b](https://www.github.com/clinical-genomics-uppsala/fada/commit/f719c2b6f0fdf19b6aa0154a14ff48335f592ced))
* update the twist cancer multiqc report ([77a626c](https://www.github.com/clinical-genomics-uppsala/fada/commit/77a626c2064214463a81f5ac9ecb6d6128fac645))


### Bug Fixes

* correct sawfish vcf name ([4ff450c](https://www.github.com/clinical-genomics-uppsala/fada/commit/4ff450cfd16901e33c19103ab70d493f37652059))


### Documentation

* add docs status badge ([a94dc83](https://www.github.com/clinical-genomics-uppsala/fada/commit/a94dc83a66e0b93509310fac0b7f93da6578d687))
* add updated schemas ([6cb81a0](https://www.github.com/clinical-genomics-uppsala/fada/commit/6cb81a07c44c2086b48ac8bb4e1e19dff50d61ca))
* add workflow for mkdocs ([a9e1473](https://www.github.com/clinical-genomics-uppsala/fada/commit/a9e147357a1dfadec45fd010df01c4fd597e699e))
* fix files for mkdocs ([3faea15](https://www.github.com/clinical-genomics-uppsala/fada/commit/3faea15fe6e35fe557a5a416e006149575d2b751))
* fixed to build docs ([4ec2a3f](https://www.github.com/clinical-genomics-uppsala/fada/commit/4ec2a3f1a2cd5e6a0d6a5df2a96e39ba46c3267a))
* update docs requirements ([2e54b32](https://www.github.com/clinical-genomics-uppsala/fada/commit/2e54b32f356e387851cf74912d235f387ee9855d))
* update README ([e88b661](https://www.github.com/clinical-genomics-uppsala/fada/commit/e88b661d4f8561be346b74e703924532d514fd75))
* update README ([932f473](https://www.github.com/clinical-genomics-uppsala/fada/commit/932f473a872160dd8d9cc083f60a87c4cfebc60e))
* update requrements versions in README ([747ddbc](https://www.github.com/clinical-genomics-uppsala/fada/commit/747ddbc60dac7c401b2f364a12bc2e8c2ec12eea))
* update schemas ([b2bb554](https://www.github.com/clinical-genomics-uppsala/fada/commit/b2bb5542747c763de0d33f12bfe325839e174200))
