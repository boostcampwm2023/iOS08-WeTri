#!/bin/bash

# 모듈 이름을 처리하는 함수
process_module_name() {
    local rawName="$1"
    local moduleType="$2"

    # 접미사 제거
    local name="${rawName%$moduleType}"

    # enum case 이름 설정
    if [[ $name =~ ^[A-Z] ]]; then
        enum_case_name="$(tr '[:upper:]' '[:lower:]' <<< ${name:0:1})${name:1}"
    else
        enum_case_name="$name"
    fi

    # 첫 글자 대문자 변환
    if [[ $name =~ ^[a-z] ]]; then
        name="$(tr '[:lower:]' '[:upper:]' <<< ${name:0:1})${name:1}"
    fi

    echo "$name $enum_case_name"
}

# Feature 모듈 생성 함수
create_feature_module() {
    local name="$1"
    local enum_case_name="$2"

    tuist scaffold Feature --name "$name"

    local feature_dir="Projects/Features/$name"
    mkdir -p "$feature_dir"

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

    local dependency_file="Plugins/DependencyPlugin/ProjectDescriptionHelpers/Dependency+Target.swift"
    if [ -f "$dependency_file" ]; then
        sed -i '' "/public enum Feature: String {/a\\
  case $enum_case_name\\
" "$dependency_file"
    fi
}

# Demo 모듈 생성 함수
create_demo_module() {
    local name="$1"

    tuist scaffold Demo --name "$name"

    local demo_dir="Projects/App/$name"
    mkdir -p "$demo_dir"

    cat <<EOF > Projects/App/$name/Project.swift
import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "${name}Demo",
  targets: .app(
    name: "${name}Demo",
    dependencies: []
  )
)
EOF
}

# 메인 로직
main() {
    local moduleType="$1"

    read -p "만들고자 할 ${moduleType}모듈의 이름을 작성하세요: " rawName

    IFS=' ' read -r name enum_case_name <<< "$(process_module_name "$rawName" "$moduleType")"

    if [[ "$moduleType" == "Feature" ]]; then
        create_feature_module "$name" "$enum_case_name"
    elif [[ "$moduleType" == "Demo" ]]; then
        create_demo_module "$name"
    else
        echo "Unknown module type: $moduleType"
        exit 1
    fi
}

# 스크립트 실행
main "$1"
