#!/usr/bin/env bash

URL="$1"
if [ -z "$URL" ]; then
  echo "不明なエラーです"
  exit 1
fi

# カレントディレクトリにeccubeディレクトリが存在しない場合
if [ ! -d ./eccube ]; then
  mkdir eccube
fi

# git clone $URL -q ./eccube
