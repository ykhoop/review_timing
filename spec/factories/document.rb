FactoryBot.define do
  trait :with_additional_documents do
    after(:create) do |_document|
      create(:document,
             code: 'privacy_policy',
             description: 'プライバシーポリシー',
             content: 'プライバシーポリシーの内容')

      create(:document,
             code: 'contact',
             description: 'お問い合わせ',
             content: 'お問い合わせの内容')

      create(:document,
             code: 'top_explanation',
             description: 'トップページ説明',
             content: 'トップページ説明の内容')
    end
  end

  factory :document do
    code { 'terms' }
    description { '利用規約' }
    content { '利用規約の内容' }

    factory :document_with_additional_documents, traits: [:with_additional_documents]
  end
end
