# frozen_string_literal: true

module Mutations
  class DeleteProject < BaseMutation
    null true

    argument :id, ID, required: true

    field :project, Types::ProjectType, null: true
    field :errors, [String], null: false

    def resolve(id: '')
      user = context[:current_user]
      return { project: nil, errors: ['Not authorized'] } unless user

      project = user.projects.find(id)

      if project.destroy
        notify_subscriber_of_deletion(project)
        { project: project }
      else
        { project: nil, errors: project.errors.full_messages }
      end
    end

    private

    def notify_subscriber_of_deletion(project)
      BrittlePinsApiSchema.subscriptions.trigger('projectDeleted', {}, project)
    end
  end
end
