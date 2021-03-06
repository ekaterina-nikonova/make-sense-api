module Types
  class QueryType < Types::BaseObject

    # Public data

    field :publicProjects, [ProjectType], null: true
    def public_projects
      Project.where(public: true)
    end

    field :publicProject, ProjectType, null: true do
      argument :id, ID, required: true
    end
    def public_project(id:)
      Project.where(public: true).find(id)
    end

    field :publicChapters, [ChapterType], null: true do
      argument :projectId, ID, required: true
    end
    def public_chapters(project_id: '')
      Project.where(public: true).find(project_id).chapters.order(:position)
    end

    # Private data

    field :projects, [ProjectType], null: true
    def projects
      context[:current_user].projects.order(:created_at).reverse_order
    end

    field :projectsForBoard, [ProjectType], null: true do
      argument :boardId, ID, required: true
    end
    def projects_for_board(board_id:)
      context[:current_user]
        .boards
        .find(board_id)
        .projects
        .order(:created_at)
        .reverse_order
    end

    field :project, ProjectType, null: true do
      argument :id, ID, required: true
    end
    def project(id:)
      context[:current_user].projects.find(id)
    end

    field :boards, [BoardType], null: true
    def boards
      context[:current_user].boards.order(:created_at).reverse_order
    end

    field :board, BoardType, null: true do
      argument :id, ID, required: true
    end
    def board(id:)
      context[:current_user].boards.find(id)
    end

    field :components, [ComponentType], null: true
    def components
      context[:current_user].components.order(:created_at).reverse_order
    end

    field :componentsForBoard, [ComponentType], null: true do
      argument :boardId, ID, required: true
    end
    def components_for_board(board_id:)
      context[:current_user]
        .boards
        .find(board_id)
        .components
        .order(:created_at)
        .reverse_order
    end

    field :component, ComponentType, null: true do
      argument :id, ID, required: true
    end
    def component(id:)
      context[:current_user].components.find(id)
    end

    field :chapters, [ChapterType], null: true do
      argument :projectId, ID, required: true
    end
    def chapters(project_id: '')
      user = context[:current_user]
      return { chapters: nil, errors: ['Not authorized'] } unless user

      user.projects.find(project_id).chapters.order(:position)
    end
  end
end
