// This is just a little console app to test the functionality

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
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
		}
	}
}
