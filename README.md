# Advanced analytics with spark
The Example Codes in "Advanced analytics with spark"

- 데이터셋 링크는 [이쪽](https://github.com/yangsuh/aas/tree/6750bbc6ff17a21577710b661e0aea005146ea4e)애서 확인


## Clone the repository 
- 아래 명령어로 repository 를 clone 한 후, 생성된 폴더로 이동합니다.
```shell
git clone https://github.com/dream2globe/advanced-spark.git
cd advanced-spark
```
- 책 예제를 다운하기 원하신다면 추가로 아래 명령어를 실행합니다.
```shell
git submodule update --init --recursive
```

## Run docker-compose

#### 실행 전 개인 개발환경으로 설정 변경  
- docker-compose.yml 파일 내용 중 volumns의 ":" 앞쪽 path를 본인의 PC 환경을 고려하여 수정합니다
    - "db"와 "spark"의 volume 이 해당됩니다.

```shell
    db:
        volumes:
            - /var/lib/mysql:/var/lib/mysql  # mariadb 파일의 저장 장소
        
    spark:
        volumes:
            - ~/workspace/apaches-project/advanced-spark:/home/jovyan/work  # workspace
```

#### docker 실행
- 메타스토어 DB를 초기화하기 위해 /script/entrypoint.sh 에서 아래 주석을 제거합니다. 
    - (주의!) 아래 명령어는 딱 한번만 실행되어야 하므로 최초 도커 실행 후에는 다시 주석으로 막아야 합니다. 
```shell
    schematool -initSchema -dbType mysql # 주석 제거
```
- 아래의 명령어로 도커를 실행합니다. \-d 옵션은 Background 실행을 의미합니다.
```shell
    docker-compose up -d 혹은 docker-compose up --build  # 변경사항 감지하면 새롭게 빌딩 시작
```

- 웹 브라우저에서 [localhost:8889](localhost:8889) 에 접속합니다. Jupyter Notebook이 실행되며, password는 `mysparklab` 입니다.

- 아래의 명령으로 도커를 중지할 수 있습니다.
```shell
    docker-compose down
```
