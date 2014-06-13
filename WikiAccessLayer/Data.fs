
//
// This is the beginnings of a data access layer that knows how to do CRUD
// operations on a very basic wiki implementation.
//
// Frank Hale <frankhale@gmail.com>
// 13 June 2014
//

namespace WikiAccessLayer

open System
open System.Linq
open System.Data
open System.Data.Linq
open Microsoft.FSharp.Data.TypeProviders
open Microsoft.FSharp.Linq
open FSharpx.Collections

//////////
// PAGE //
//////////

type Page(guid, createdOn, modifiedOn, author, title, body) = 
  let mutable _guid : string = guid
  let mutable _createdOn : DateTime = createdOn
  let mutable _modifiedOn : Nullable<DateTime> = modifiedOn
  let mutable _author : int = author
  let mutable _title : string = title
  let mutable _body : string = body  
    
  member this.Guid 
    with public get () = _guid
    and public set (value) = _guid <- value
    
  member this.CreatedOn 
    with public get () = _createdOn
    and public set (value) = _createdOn <- value
    
  member this.ModifiedOn 
    with public get () = _modifiedOn
    and public set (value) = _modifiedOn <- value
    
  member this.Author 
    with public get () = _author
    and public set (value) = _author <- value
    
  member this.Title 
    with public get () = _title
    and public set (value) = _title <- value
    
  member this.Body 
    with public get () = _body
    and public set (value) = _body <- value

/////////
// TAG //
/////////
  
type Tag(name : string) = 
  let mutable _name : string = name
    
  member this.Name 
    with public get () = _name
    and public set (value) = _name <- value
  
type PageTag(page : int, tag : int) = 
  let mutable _page : int = page
  let mutable _tag : int = tag
    
  member this.PageId 
    with public get () = _page
    and public set (value) = _page <- value
    
  member this.TagId 
    with public get () = _tag
    and public set (value) = _tag <- value
  
/////////////
// COMMENT //
/////////////

type Comment(guid, createdOn, modifiedOn, author, page, text) = 
  let mutable _guid : string = guid
  let mutable _createdOn : DateTime = createdOn
  let mutable _modifiedOn : Nullable<DateTime> = modifiedOn
  let mutable _author : int = author
  let mutable _page : int = page
  let mutable _text : string = text
    
  member this.Guid 
    with public get () = _guid
    and public set (value) = _guid <- value
    
  member this.CreatedOn 
    with public get () = _createdOn
    and public set (value) = _createdOn <- value
    
  member this.ModifiedOn 
    with public get () = _modifiedOn
    and public set (value) = _modifiedOn <- value
    
  member this.Author 
    with public get () = _author
    and public set (value) = _author <- value
    
  member this.Page 
    with public get () = _page
    and public set (value) = _page <- value
    
  member this.Text 
    with public get () = _text
    and public set (value) = _text <- value

  //////////
  // USER //
  //////////

  type User(id, userName, fullName) = 
    let mutable _id : int = id
    let mutable _fullName : string = userName
    let mutable _userName : string = fullName
    
    member this.Id 
      with public get () = _id
      and public set (value) = _id <- value
    
    member this.FullName 
      with public get () = _fullName
      and public set (value) = _fullName <- value
    
    member this.UserName 
      with public get () = _userName
      and public set (value) = _userName <- value

  ///////////////////////
  // DATA ACCESS LAYER //
  ///////////////////////
  
  module public Data =

    type dbSchema = SqlDataConnection<"Data Source=.\SQLEXPRESS;Initial Catalog=wiki;Integrated Security=True">

    let db = dbSchema.GetDataContext()
    let usersTable = db.Users
    let pagesTable = db.Pages
    let commentsTable = db.Comments
    let tagsTable = db.Tags
    let pageTagsTable = db.PageTags

    //////////
    // USER //
    //////////

    let GetUsers = 
      query { 
        for user in usersTable do
          select user
      }
      |> Seq.map(fun u -> new User(u.Id, u.User_name, u.Full_name))


    let GetUserById id = 
      query { 
        for u in db.Users do
          where (u.Id = id)
          select u                  
      }
      |> Seq.map(fun u -> new User(u.Id, u.User_name, u.Full_name))
      |> Seq.tryHead   

    let GetUserByUserName userName = 
      query { 
        for u in db.Users do
          where (u.User_name = userName)
          select u
      }
      |> Seq.map(fun u -> new User(u.Id, u.User_name, u.Full_name))
      |> Seq.tryHead
      |> function        
         | None -> Unchecked.defaultof<User>
         | Some u -> u
              
    let UpdateUser userName fullName = 
      query { 
        for u in db.Users do
          where (u.User_name = userName)
          select u
          headOrDefault
      }
      |> function
         | null -> failwith "User does not exist."
         | u -> u.Full_name <- fullName
                db.DataContext.SubmitChanges()

    let CreateUser fullName userName = 
      let u = new dbSchema.ServiceTypes.Users(Full_name = fullName, User_name = userName)
      usersTable.InsertOnSubmit u
      db.DataContext.SubmitChanges()

    /////////////
    // COMMENT //
    /////////////

    let GetCommentById id = 
      query { 
        for c in db.Comments do
          where (c.Id = id)
          select c
      }
      |> Seq.map(fun c -> new Comment(c.Guid, c.Created_on, c.Modified_on, c.Author, c.Id, c.Text))      

    let GetCommentByGuid guid = 
      query { 
        for c in db.Comments do
          where (c.Guid = guid)
          select c
      }
      |> Seq.map(fun c -> new Comment(c.Guid, c.Created_on, c.Modified_on, c.Author, c.Id, c.Text))

    let GetRawCommentByGuid guid = 
      query { 
        for c in db.Comments do
          where (c.Guid = guid)
          select c
      }
      |> Seq.tryHead 

    let CreateComment pageId author comment = 
      let c = new dbSchema.ServiceTypes.Comments(Page = pageId, Author = author, Text = comment, Created_on = DateTime.Now)
      commentsTable.InsertOnSubmit c
      db.DataContext.SubmitChanges

    let EditComment guid text =      
      let makeChangesToComment(c : dbSchema.ServiceTypes.Comments) =
        c.Modified_on <- System.Nullable DateTime.Now
        c.Text <- text
        db.DataContext.SubmitChanges()
      
      match GetRawCommentByGuid guid with
      | None -> ()
      | Some c -> makeChangesToComment c
      

    let DeleteComment guid = 
      match GetRawCommentByGuid guid with
      | None -> ()
      | Some c -> db.Comments.DeleteOnSubmit c
                  db.DataContext.SubmitChanges()

    /////////
    // TAG //
    /////////

    let CreateTag name =
      let tagExists = query {
        for t in db.Tags do
        where (t.Name = name)
        select t
        headOrDefault  
      }

      if (tagExists = null) then 
        let tag = new dbSchema.ServiceTypes.Tags(Name = name)
        db.Tags.InsertOnSubmit tag
        db.DataContext.SubmitChanges()
        tag.Id
      else 
        tagExists.Id

    let GetTagId name =
      query {
        for t in db.Tags do
        where (t.Name = name)
        select t        
      }
      |> Seq.tryHead
      |> function
         | None -> -1
         | Some t -> t.Id

    let CreatePageTag pageId tagId =
      let tagExists = query {
        for t in db.PageTags do
        where (t.Page = pageId &&
               t.Tag = tagId)
        select t
        headOrDefault
      }

      if (tagExists = null) then      
        let pt = new dbSchema.ServiceTypes.PageTags()
        pt.Page <- pageId
        pt.Tag <- tagId
        db.PageTags.InsertOnSubmit pt
        db.DataContext.SubmitChanges()
        pt.Id
      else
        -1

    let DeleteTag name =
      query {
        for t in db.Tags do
        where (t.Name = name)
        select t
      }
      |> Seq.tryHead
      |> function
          | None -> ()
          | Some t -> db.Tags.DeleteOnSubmit t
                      db.DataContext.SubmitChanges()

    let DeletePageTag pageId name =
      let tag = query {
        for t in db.Tags do
        where (t.Name = name)
        select t
        headOrDefault
      }

      if (tag <> null) then
        query {
          for pt in db.PageTags do
          where (pt.Page = pageId)
          select pt
        }
        |> Seq.tryHead
        |> function
           | None -> () 
           | Some pt -> db.PageTags.DeleteOnSubmit pt
                        db.DataContext.SubmitChanges()

    let GetPagesForTag name =
      query {
        for p in db.PagesWithTags do
        where (p.Tag = name)
        select p
      }
      |> Seq.map(fun x -> new Page(guid = x.Guid, createdOn = x.Created_on, modifiedOn = x.Modified_on, author = x.Author, title = x.Title, body = x.Body))

    let GetTagsForPage guid =
      let tagsForPage pageId =
        query {
          for t in db.TagsForPage do
          where (pageId = t.Id)
          select t
        }
    
      query {
        for p in db.Pages do
        where (p.Guid = guid)
        select p
      }
      |> Seq.tryHead
      |> function
         | None -> [] |> seq
         | Some p -> tagsForPage p.Id |> seq         

    //////////
    // PAGE //
    //////////

    let GetPageById id = 
      query { 
        for p in pagesTable do
          select p
      }
      |> Seq.map(fun p -> new Page(p.Guid, p.Created_on, p.Modified_on, p.Author, p.Title, p.Body))
      |> Seq.tryHead
      |> function
         | None -> Unchecked.defaultof<Page>
         | Some p -> p
               
    let GetPages = 
      query { 
        for p in pagesTable do
          select p
      }
      |> Seq.map(fun p -> new Page(p.Guid, p.Created_on, p.Modified_on, p.Author, p.Title, p.Body))

    let GetPageByGuid guid = 
      query { 
        for p in db.Pages do
          where (p.Guid = guid)
          select p
      }
      |> Seq.map(fun p -> new Page(p.Guid, p.Created_on, p.Modified_on, p.Author, p.Title, p.Body))
      |> Seq.tryHead

    let GetRawPageByGuid guid = 
      query { 
        for p in db.Pages do
          where (p.Guid = guid)
          select p
      }
      |> Seq.tryHead

    let CreatePage author title body = 
      let p = 
        new dbSchema.ServiceTypes.Pages(Guid = Guid.NewGuid().ToString(), Author = author, Title = title, Body = body, 
                                        Created_on = DateTime.Now)
      pagesTable.InsertOnSubmit p
      db.DataContext.SubmitChanges()
      p.Id

    let CreatePageWithTags author title body tags =
      let id = CreatePage author title body
      tags |> Seq.iter(fun t -> CreatePageTag id <| CreateTag t |> ignore)
      id

    let EditPage guid title body =       
      let makeChangesToPage(p : dbSchema.ServiceTypes.Pages) =
        p.Modified_on <- System.Nullable DateTime.Now
        p.Title <- title
        p.Body <- body
        db.DataContext.SubmitChanges()
      
      match GetRawPageByGuid guid with
      | None -> ()
      | Some p -> makeChangesToPage p
      
    let DeletePage guid =
      match GetRawPageByGuid guid with
      | None -> ()
      | Some p -> db.Pages.DeleteOnSubmit p
                  db.DataContext.SubmitChanges()