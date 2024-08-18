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
  associatedtype RepositoryType

  func create(input: CreateInput) async throws -> CreateOutput
  static var live: RepositoryType { get }
  static var stubbed: RepositoryType { get }
}

public protocol ReadRepository {
  associatedtype ReadInput = Never
  associatedtype ReadOutput = Never
  associatedtype RepositoryType

  func read(input: ReadInput) async throws -> ReadOutput
  static var live: RepositoryType { get }
  static var stubbed: RepositoryType { get }
}

public protocol ReadAllRepository {
  associatedtype ReadInput = Never
  associatedtype ReadOutput = Never
  associatedtype RepositoryType

  func readAll(input: ReadInput) async throws -> [ReadOutput]
  static var live: RepositoryType { get }
  static var stubbed: RepositoryType { get }
}

public protocol UpdateRepository {
  associatedtype UpdateInput = Never
  associatedtype UpdateOutput = Never
  associatedtype RepositoryType

  func update(input: UpdateInput) async throws -> UpdateOutput
  static var live: RepositoryType { get }
  static var stubbed: RepositoryType { get }
}

public protocol DeleteRepository {
  associatedtype DeleteInput = Never
  associatedtype DeleteOutput = Never
  associatedtype RepositoryType

  func delete(input: DeleteInput) async throws -> DeleteOutput
  static var live: RepositoryType { get }
  static var stubbed: RepositoryType { get }
}

public typealias RemoteUsersRepository = ReadRepository
public typealias RemoteUserDetailRepository = ReadRepository
public typealias RemoteGitRepoRepository = ReadRepository
