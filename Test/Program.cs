// This is just a little console app to test the functionality

using System;
using WikiAccessLayer;

namespace Test
{
	class Program
	{
		static void Main(string[] args)
		{
			//Data.CreateUser("Frank Hale", "frankhale@gmail.com");

			var user = Data.GetUserByUserName("frankhale@gmail.com");

			//var pageId = Data.CreatePage(user.Id, "Test Page #3", "Foobar barfoo");
			//var tagId = Data.CreateTag("testing");

			//Data.CreatePageTag(1, 3);
			//Data.DeletePageTag(3, "testing");

			var pageId = Data.CreatePageWithTags(user.Id, "Test page with tags #2", "This is a test page #2", new String[] { "bar", "foo", "abc", "sweet" });
			var page = Data.GetPageById(pageId);

			if (page != null)
			{
				var tags = Data.GetTagsForPage(page.Guid);

				Console.WriteLine("Page Title: {0}", page.Title);

				foreach (var t in tags)
				{
					Console.WriteLine("Page Tag: {0}", t.Tag);
				}
			}
		}
	}
}
