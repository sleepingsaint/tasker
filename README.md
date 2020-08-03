![Tasker Icon](https://img.icons8.com/dusk/64/000000/task.png)
# Tasker

Handy application to manage your tasks effectively and stay productive. Made using powerful **Flutter** framework with nice and sleek interface makes your time on the app more enjoyable.

Icon from [icons8.com](https://img.icons8.com/dusk/64/000000/task.png).

### Features 

* Orgainzing tasks according to dates.
* Assigning priorities to the tasks.
* Getting remainders for the task.

### Packages Used

| Package | Used for |
| ------- | -------- |
| [table calendar](https://pub.dev/packages/table_calendar) | orgainzing calendar |
| [Provider](https://pub.dev/packages/provider)  | state management |
| [chips choice](https://pub.dev/packages/chips_choice) | filtering chips |
| [sqflite](https://pub.dev/packages/sqflite) | backend for storing tasks |
| [date format](https://pub.dev/packages/date_format) | formating date to String
| [flutter icons](https://pub.dev/packages/flutter_icons) | icons on the app |
| [flutter launcher icons](https//pub.dev/packages/flutter_launcher_icons) | adding a launcher icon |
| [flutter local notifications](https//pub.dev/packages/flutter_local_notifications) | local notifications |

Thanks to all the developers for making mobile development easy for everyone.

### Getting Started

* Make sure you have flutter installed and configured properly, if not refer this [link](https://flutter.dev/docs/get-started/install).
* Clone the repo and run the below command to get all the packages

    ```
    flutter pub get
    ```
* Create KeyStore

    If you have an existing keystore, skip this step. If not, create one by running the following at the command line:

    * On Mac/Linux, use the following command:
        ```
        keytool -genkey -v -keystore ~/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key
        ```
    * On Windows, use the following command:
        ```
        keytool -genkey -v -keystore c:\Users\<USER_NAME>\key.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias key
        ```
    This command stores the key.jks file in your home directory. If you want to store it elsewhere, change the argument you pass to the -keystore parameter.

* Reference the keystore from the app

    modify the file **tasker/android/key.properties** that contains a reference to your keystore:

    ```
    storePassword=<password from previous step>
    keyPassword=<password from previous step>
    keyAlias=key
    storeFile=<location of the key store file, such as /Users/<user name>/key.jks>
    ```
* If you encountered any problems in the above steps refer to this [link](https://flutter.dev/docs/deployment/android#create-a-keystore).
* Final part Creating the apk:

    Run the below command to build a fat apk (single apk for different architectures).
    
    ```
    flutter build apk
    ```
    You can find the apk at **tasker/build/app/outputs/apk/release/app-release.apk**

### Contributions

* contributions of any kind (ideas, designs, code) is highly appreciated. 