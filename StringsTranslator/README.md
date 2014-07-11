StringsTranslator will translate a strings file into 40 different languages. This uses the microsoft translator API. You can translate up to 2,000,000 characters per month for free using the microsoft translator API. This should be enough for most people, but if it's not just simply buy a plan that allows you to translate more text

Setup:

1. To get translation working you must create an app for the microsoft translation API. Go here to learn how to do that. 

http://blogs.msdn.com/b/translation/p/gettingstarted1.aspx

2. After the app creation on the microsoft side is completd copy and paste the client id and app id into the appropriate variables at the top of main.swift

3. Set the path for the main strings file you'd like to convert to all the other languages at the top of main.swift

4. Set the language that is used in the strings file at the top of main.swift

5. Set the output directory for the string files. This could be your desktop or any directory.

6. Run the program. This should take a while depending on your connection speed.

7. If you didn't set your output directory to the directory of your application's code, copy the translated language directories into your applications code directory.