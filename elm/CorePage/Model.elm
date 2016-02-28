module CorePage.Model where

type Action
  = NoOp
  | UserChanged String
  | RepoChanged String

  | LoadIssuesCommand Int
  | IssueListLoaded Int (Maybe (List Issue))
  --
  -- | PageClicked Int
  --
  -- | IssueClicked Int
  -- | ChangePathCommand ()
  | CommentListLoaded Int (Maybe (List Comment))
  -- | MainPageClicked
  -- | PathChanged String
  | LoadSingleIssueCommand Int
  | SingleIssueLoaded (Maybe Issue)
  -- | NextPageCommand Int
  -- | LoadCommentsCommand Int

type alias Model =
  { currentUser : String
  , currentRepo : String
  , currentPage : PageData
  , issues : List Issue
  -- , currentIssue: Int
  -- , comments : List ()
  }

type PageData
  = IssuesPageData Int (List Issue)
  | CommentsPageData Issue (List Comment)

type alias Issue =
  { number : Int
  , title : String
  , body : Maybe String
  , labels : List Label
  , state : String
  , authorName : String
  , authorAvatarUrl : String
  , commentCount : Int
  }

emptyIssue : Issue
emptyIssue =
  Issue 0 "empty title" (Just "empty body") [] "open" "empty author" "" 0

type alias Label =
  { url : String
  , name : String
  , color : String
  }

type alias Comment =
  { body : String
  , authorName : String
  , authorAvatarUrl : String
  }
