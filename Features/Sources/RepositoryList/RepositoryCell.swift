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
          VStack(alignment: .leading) {

            Text(model.title)
              .font(.system(size: 14))
              .lineLimit(1)
              .foregroundStyle(Color.text)

            if let detail = model.detail {
              Text(detail)
                .font(.system(size: 12))
                .lineLimit(1)
                .foregroundStyle(.gray)
            }

            HStack(spacing: 4) {
              Icon.starFill
              DetailTextView("\(model.starCount)")
                .padding(.trailing, 16)

              Icon.eyeFill
              DetailTextView("\(model.watchersCount)")
                .padding(.trailing, 16)

              if let language = model.language {
                DetailTextView(language)
              }
            }
          }
          Spacer()
        }
        .frame(height: 64)
        .frame(maxWidth: .infinity)
        .padding([.leading, .trailing], 8.0)
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
