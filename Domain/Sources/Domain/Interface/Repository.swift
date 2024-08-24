//
//  Repository.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/18/24.
//

import Foundation

public protocol PrepareRepository {
  func prepare() async throws
}

public protocol CreateRepository {
  associatedtype CreateInput = Never
  associatedtype CreateOutput = Never

  func create(input: CreateInput) async throws -> CreateOutput
  static var live: Self { get }
  static var stubbed: Self { get }
}

public protocol ReadRepository {
  associatedtype ReadInput = Never
  associatedtype ReadOutput = Never

  func read(input: ReadInput) async throws -> ReadOutput
  static var live: Self { get }
  static var stubbed: Self { get }
}

public protocol ReadAllRepository {
  associatedtype ReadInput = Never
  associatedtype ReadOutput = Never

  func readAll(input: ReadInput) async throws -> [ReadOutput]
  static var live: Self { get }
  static var stubbed: Self { get }
}

public protocol UpdateRepository {
  associatedtype UpdateInput = Never
  associatedtype UpdateOutput = Never

  func update(input: UpdateInput) async throws -> UpdateOutput
  static var live: Self { get }
  static var stubbed: Self { get }
}

public protocol DeleteRepository {
  associatedtype DeleteInput = Never
  associatedtype DeleteOutput = Never

  func delete(input: DeleteInput) async throws -> DeleteOutput
  static var live: Self { get }
  static var stubbed: Self { get }
}

public protocol UsersRepository: ReadRepository {
  func read(input: Int) async throws -> UsersResponse
}

public protocol UserDetailRepository: ReadRepository {
  func read(input: String) async throws -> UserDetail
}

public protocol GitRepoRepository: ReadRepository {
  func read(input: RepositoryQuery) async throws -> RepositoryResponse
}
