# benri-dockerfiles
手元で色々試すために気軽に作って壊せるdocker環境を用意するためのファイル群

# Dockerイメージのビルド
基本的にリポジトリ直下に`.zshrc`や`.ssh`を配置するので、ビルドもリポジトリ直下でコマンドを実行する
```shell
docker build -f <dockerfile> -t <イメージ名> .
```
ubuntu ベースのイメージは `--add-host="archive.ubuntu.com:91.189.91.38"` を追加するとちょっとはやい（気がする