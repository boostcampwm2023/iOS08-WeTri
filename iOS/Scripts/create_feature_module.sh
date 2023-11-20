#!/bin/bash
# Tuist Feature Module 생성을 편리하게 하고자 만들어진 스크립트 파일입니다.

# Feature 이름 받기
read -p "만들고자 할 Feature모듈의 이름을 작성하세요: " name


# 첫 글자가 대문자인 경우 소문자로 변환하여 enum case 변수 설정
if [[ $name =~ ^[A-Z] ]]; then
    enum_case_name="$(tr '[:upper:]' '[:lower:]' <<< ${name:0:1})${name:1}"
else
    enum_case_name="$name"
fi

# 첫 글자가 소문자인 경우에만 대문자로 변환
if [[ $name =~ ^[a-z] ]]; then
    name="$(tr '[:lower:]' '[:upper:]' <<< ${name:0:1})${name:1}"
fi


tuist scaffold Feature --name "$name"

# Project.swift 파일 생성
cat <<EOF > Projects/Features/$name/Project.swift
import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "${name}Feature",
  targets: .feature(
    .${enum_case_name},
    testingOptions: [.unitTest],
    dependencies: [],
    testDependencies: []
  )
)
EOF

# Dependency+Target.swift 파일 수정
dependency_file="Plugins/DependencyPlugin/ProjectDescriptionHelpers/Dependency+Target.swift"
if [ -f "$dependency_file" ]; then
    # Feature enum에 새 case 추가
    sed -i '' "/public enum Feature: String {/a\\
  case $enum_case_name\\
" "$dependency_file"
fi

