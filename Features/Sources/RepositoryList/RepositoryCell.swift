//
//  RepositoryCell.swift
//  DevHub
//
//  Created by Mohammed Rokon Uddin on 8/18/24.
//

import Common
import Domain
import SwiftUI

public struct RepositoryCell: View {
  struct Model {
    let avatar: String?
    let title: String
    let detail: String?
    let starCount: Int
    let watchersCount: Int
    let language: String?
  }

  let model: Model
  var action: (() -> Void)?

  init(model: Model, action: (() -> Void)? = nil) {
    self.model = model
    self.action = action
  }

  public var body: some View {
    Button(
      action: {
        action?()
      },
      label: {
        HStack(alignment: .center) {
          Avatar(model.avatar, size: 48)
            .accessibilityHidden(true)
            .accessibilityIdentifierLeaf("Avatar")
          VStack(alignment: .leading) {
            Text(model.title)
              .font(.system(size: 14))
              .lineLimit(1)
              .foregroundStyle(Color.text)
              .accessibilityLabel("Repository name")
              .accessibilityValue(model.title)
              .accessibilityIdentifierLeaf("RepositoryName")

            if let detail = model.detail {
              Text(detail)
                .font(.system(size: 12))
                .lineLimit(1)
                .foregroundStyle(.gray)
                .accessibilityIdentifierLeaf("RepositoryDetail")
            }

            HStack(spacing: 4) {
              Icon.starFill
              DetailTextView("\(model.starCount)")
                .accessibilityLabel("Number of stars")
                .accessibilityValue("\(model.starCount)")
                .padding(.trailing, 16)
                .accessibilityIdentifierLeaf("StarCount")

              Icon.eyeFill
              DetailTextView("\(model.watchersCount)")
                .padding(.trailing, 16)
                .accessibilityIdentifierLeaf("WatcherCount")

              if let language = model.language {
                DetailTextView(language)
                  .accessibilityIdentifierLeaf("Language")
              }
            }
          }
          Spacer()
        }
        .frame(height: 64)
        .frame(maxWidth: .infinity)
        .padding([.leading, .trailing], 8.0)
        .accessibilityElement(children: .combine)
        .accessibilityHint("Repository information")
      }
    )
    .background(Color.foreground)
    .cornerRadius(8.0)
  }
}

extension GitHubRepository {
  var toViewModel: RepositoryCell.Model {
    RepositoryCell.Model(
      avatar: owner.avatarURL,
      title: name,
      detail: description,
      starCount: stargazersCount,
      watchersCount: watchersCount, language: language)
  }
}
