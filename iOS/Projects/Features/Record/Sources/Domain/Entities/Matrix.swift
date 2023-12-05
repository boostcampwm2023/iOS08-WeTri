//
//  Matrix.swift
//  RecordFeature
//
//  Created by MaraMincho on 12/4/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

struct MatrixOfTwoDimension {
  var value: [[Double]]
  var countOfRow: Int { return value.count }
  var countOfColumn: Int { return value[0].count }

  init(_ value: [[Double]]) {
    self.value = value
  }

  func add(_ secondMatrix: MatrixOfTwoDimension) -> Self? {
    guard
      countOfRow == secondMatrix.countOfRow,
      countOfColumn == secondMatrix.countOfColumn
    else {
      return nil
    }
    return .init(zip(value, secondMatrix.value)
      .map { value1, value2 in
        return zip(value1, value2).map { $0.0 + $0.1 }
      }
    )
  }

  func sub(_ secondMatrix: MatrixOfTwoDimension) -> Self? {
    guard
      countOfRow == secondMatrix.countOfRow,
      countOfColumn == secondMatrix.countOfColumn
    else {
      return nil
    }
    return .init(zip(value, secondMatrix.value)
      .map { value1, value2 in
        return zip(value1, value2).map { $0.0 - $0.1 }
      }
    )
  }

  func multiply(_ secondMatrix: MatrixOfTwoDimension) -> Self? {
    let matrixA = value
    let rowsA = value.count
    let colsA = value[0].count
    let matrixB = secondMatrix.value
    let rowsB = secondMatrix.value.count
    let colsB = secondMatrix.value[0].count

    // 행렬 곱셈이 가능한지 확인
    guard colsA == rowsB else {
      return nil // 곱셈이 불가능한 경우
    }

    var result = Array(repeating: Array(repeating: 0.0, count: colsB), count: rowsA)

    for i in 0 ..< rowsA {
      for j in 0 ..< colsB {
        for k in 0 ..< colsA {
          result[i][j] += matrixA[i][k] * matrixB[k][j]
        }
      }
    }

    return .init(result)
  }

  func transPose() -> Self {
    var resValue = Array(repeating: Array(repeating: 0.0, count: countOfRow), count: countOfColumn)
    for rowInd in 0 ..< countOfRow {
      for colInd in 0 ..< countOfColumn {
        resValue[colInd][rowInd] = value[rowInd][colInd]
      }
    }
    return .init(resValue)
  }

  func invert() -> Self? {
    let matrix = value
    let n = matrix.count
    guard n > 0 && (matrix[0].count == n) else { return nil }
    // 원본 행렬과 단위 행렬을 합쳐 확장 행렬을 생성
    var augmented = matrix
    for i in 0 ..< n {
      augmented[i] += Array(repeating: 0.0, count: n)
      augmented[i][n + i] = 1.0
    }
    for i in 0 ..< n {
      // 피벗을 1로 만들기
      if augmented[i][i] == 0 {
        var hasNonZero = false
        for j in i + 1 ..< n {
          if augmented[j][i] != 0 {
            augmented.swapAt(i, j)
            hasNonZero = true
            break
          }
        }
        if !hasNonZero { return nil } // 역행렬이 존재하지 않음
      }
      let pivot = augmented[i][i]
      for j in 0 ..< 2 * n {
        augmented[i][j] /= pivot
      }
      // 다른 모든 행을 0으로 만들기
      for k in 0 ..< n {
        if i != k {
          let factor = augmented[k][i]
          for j in 0 ..< 2 * n {
            augmented[k][j] -= factor * augmented[i][j]
          }
        }
      }
    }
    // 역행렬 부분만 추출
    var inverseMatrix = [[Double]](repeating: [Double](repeating: 0.0, count: n), count: n)
    for i in 0 ..< n {
      for j in 0 ..< n {
        inverseMatrix[i][j] = augmented[i][j + n]
      }
    }
    return .init(inverseMatrix)
  }
}
