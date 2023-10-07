# Hangeun AWS 아키텍쳐
Hangeun에서 사용되는 AWS 리소스와 아키텍쳐에 대한 그림입니다.
![./image/DF_AWS.png]
이를 바탕으로 위의 Terraform 코드를 작성했으며, 해당 Terraform 코드의 사용법은 아래와 같습니다


## Terraform 설치
### MacOS 기준
```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform

# terraform 이 정상적으로 설치 됐는지 확인
terraform --version
```

## Terraform 코드로 이동
```bash
cd terraform
```

## Terraform 초기화
```bash
terraform init
```

## Terraform 코드 활성화
```bash
terraform apply

# 이후 나오는 멘트에서 yes 입력합니다.
```

- 위의 작업이 끝난다면, AWS 리소스는 사용준비가 끝나게 됩니다.
