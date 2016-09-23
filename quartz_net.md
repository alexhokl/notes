##### Example on job configuration
```xml
<?xml version="1.0" encoding="utf-8"?>
  <!-- This file contains job definitions in schema version 2.0 format -->
<job-scheduling-data xmlns="http://quartznet.sourceforge.net/JobSchedulingData" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="2.0">
  <processing-directives>
    <overwrite-existing-data>true</overwrite-existing-data>
  </processing-directives>
  <schedule>
    <job>
      <name>TestJob</name>
      <group>TestJobGroup</group>
      <description>Test Job</description>
      <job-type>Namespace.Jobs, Namespace.Jobs.TestJob</job-type>
      <durable>true</durable>
      <recover>false</recover>
      <job-data-map>
        <entry>
          <key>Parameter1</key>
          <value>Value1</value>
        </entry>
      </job-data-map>
    </job>
    <trigger>
      <cron>
        <name>TestJobTrigger</name>
        <group>TestJobTriggerGroup</group>
        <description>TestJob Trigger</description>
        <job-name>TestJob</job-name>
        <job-group>TestJobGroup</job-group>
        <misfire-instruction>SmartPolicy</misfire-instruction>
        <cron-expression>0 0/5 * * * ?</cron-expression>
      </cron>
    </trigger>
    <trigger>
      <simple>
        <name>TestJobTrigger Trigger</name>
        <group>TestJobTriggerGroup</group>
        <description></description>
        <job-name>TestJob</job-name>
        <job-group>TestJobGroup</job-group>
        <misfire-instruction>SmartPolicy</misfire-instruction>
        <repeat-count>0</repeat-count>
        <repeat-interval>10000</repeat-interval>
      </simple>
    </trigger>
  </schedule>
</job-scheduling-data>
```

##### Example on service configuration
```xml
<?xml version="1.0" encoding="utf-8" ?>
<configuration>
  <configSections>
    <section name="quartz" type="System.Configuration.NameValueSectionHandler, System, Version=1.0.5000.0,Culture=neutral, PublicKeyToken=b77a5c561934e089" />
    <section name="log4net" type="log4net.Config.Log4NetConfigurationSectionHandler, log4net" />
    <sectionGroup name="common">
      <section name="logging" type="Common.Logging.ConfigurationSectionHandler, Common.Logging" />
    </sectionGroup>
  </configSections>

  <appSettings>
  </appSettings>

  <common>
    <logging>
      <factoryAdapter type="Common.Logging.Log4Net.Log4NetLoggerFactoryAdapter, Common.Logging.Log4net1211">
        <arg key="configType" value="INLINE" />
      </factoryAdapter>
    </logging>
  </common>

  <log4net>
    <!-- see http://logging.apache.org/log4net/release/config-examples.html for examples -->
    <appender name="AdoNetAppender" type="log4net.Appender.AdoNetAppender">
      <bufferSize value="1" />
      <connectionType value="System.Data.SqlClient.SqlConnection, System.Data, Version=1.0.3300.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" />
      <connectionString value="..." />
      <commandText value="INSERT INTO Log ([Date],[Thread],[Level],[Logger],[Message],[Exception]) VALUES (@log_date, @thread, @log_level, @logger, @message, @exception)" />
      <parameter>
        <parameterName value="@log_date" />
        <dbType value="DateTime" />
        <layout type="log4net.Layout.RawTimeStampLayout" />
      </parameter>
      <parameter>
        <parameterName value="@thread" />
        <dbType value="String" />
        <size value="255" />
        <layout type="log4net.Layout.PatternLayout">
          <conversionPattern value="%thread" />
        </layout>
      </parameter>
      <parameter>
        <parameterName value="@log_level" />
        <dbType value="String" />
        <size value="50" />
        <layout type="log4net.Layout.PatternLayout">
          <conversionPattern value="%level" />
        </layout>
      </parameter>
      <parameter>
        <parameterName value="@logger" />
        <dbType value="String" />
        <size value="255" />
        <layout type="log4net.Layout.PatternLayout">
          <conversionPattern value="%logger" />
        </layout>
      </parameter>
      <parameter>
        <parameterName value="@message" />
        <dbType value="String" />
        <size value="8000" />
        <layout type="log4net.Layout.PatternLayout">
          <conversionPattern value="%message" />
        </layout>
      </parameter>
      <parameter>
        <parameterName value="@exception" />
        <dbType value="String" />
        <size value="8000" />
        <layout type="log4net.Layout.ExceptionLayout" />
      </parameter>
    </appender>
    <root>
      <level value="INFO" />
      <appender-ref ref="AdoNetAppender" />
    </root>
  </log4net>

  <!--
    We use quartz.config for this server, you can always use configuration section if you want to.
    Configuration section has precedence here.  
  -->
  <!--
  <quartz >
  </quartz>
  -->
</configuration>
```

##### Example on error logging in Global.asax.cs
```cs
using System;
using System.Web;
using log4net;
using log4net.Config;


namespace Alexhokl
{
    public class Global : System.Web.HttpApplication
    {
        void Application_Start(object sender, EventArgs e)
        {
            XmlConfigurator.Configure();
        }

        void Application_Error(object sender, EventArgs e)
        {
            // Code that runs when an unhandled error occurs
            log.Error("Exception was unhandled.", Server.GetLastError());
        }

        private static readonly ILog log = LogManager.GetLogger(typeof(Global));
    }
}
```

##### Creating SQL table for log storage
```sql
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Log]') AND type in (N'U'))
  DROP TABLE [dbo].[Log]
GO

CREATE TABLE [dbo].[Log](
  [Id] [int] IDENTITY(1,1) NOT NULL,
	[Date] [datetime] NOT NULL,
	[Thread] [varchar](255) NOT NULL,
	[Level] [varchar](50) NOT NULL,
	[Logger] [varchar](255) NOT NULL,
	[Message] [nvarchar](max) NOT NULL,
	[Exception] [nvarchar](max) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO
```
