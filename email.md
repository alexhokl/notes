- [Mail Server](#mail-server)
    + [SPF](#spf)
    + [DKIM](#dkim)
    + [DMARC](#dmarc)
- [G Suite](#g-suite)
    + [Migrate from other webmail providers to G Suite](#migrate-from-other-webmail-providers-to-g-suite)
    + [G Suite Toolbox](#g-suite-toolbox)
    + [GMail](#gmail)
- [Microsoft Exchange](#microsoft-exchange)
    + [Migration](#migration)
    + [DKIM](#dkim-1)
    + [Spam management](#spam-management)
    + [PST and OST](#pst-and-ost)
    + [Configuration](#configuration)
- [Troubleshooting](#troubleshooting)
____

# Mail Server

### SPF

Sender Policy Framework (SPF) is an email validation protocol designed to
detect and block email spoofing by providing a mechanism to allow receiving
mail exchangers to verify that incoming mail from a domain comes from an IP
Address authorized by that domain's administrators.

SMTP permits any computer to send email claiming to be from any source address.
This is exploited by spammers who often use forged email addresses, making it
more difficult to trace a message back to its source, and easy for spammers to
hide their identity in order to avoid responsibility. It is also used in
phishing techniques, where users can be duped into disclosing private
information in response to an email purportedly sent by an organization such as
a bank.

Some mail recipients require SPF. If you don’t add an SPF record for your
domain, your messages can be marked as spam or even bounce back.

An SPF record lists the mail servers that are permitted to send email on behalf
of your domain. If a message is sent through an unauthorized mail server, it’s
reported and can be marked as spam.

For best practices, use SPF and DomainKeys Identified Mail (DKIM). SPF
validates who’s relaying the email, while DKIM adds a digital signature to
verify the email’s content.

See [Configure SPF records to work with
G Suite](https://support.google.com/a/answer/33786?hl=en).

### DKIM

Use the DomainKeys Identified Mail (DKIM) standard to help prevent email
spoofing on outgoing messages.

Email spoofing is when email content is changed to make the message appear from
someone or somewhere other than the actual source. Spoofing is a common
unauthorized use of email, so some email servers require DKIM to prevent email
spoofing.

DKIM adds an encrypted signature to the header of all outgoing messages. Email
servers that get these messages use DKIM to decrypt the message header,  and
verify the message was not changed after it was sent.

DKIM verifies message content is authentic and not changed.

See

- [About DKIM](https://support.google.com/a/answer/174124)
- [1. Generate the DKIM domain key](https://support.google.com/a/answer/174126)
- [2. Add domain key to DNS records](https://support.google.com/a/answer/173535)
- [3. Turn on DKIM signing](https://support.google.com/a/answer/180504)
- [Update DNS records for a subdomain](https://support.google.com/a/answer/177063)

### DMARC

Domain-based Message Authentication, Reporting and Conformance (DMARC) is an
email-validation system designed to detect and prevent email spoofing. DMARC
counters the illegitimate usage of the exact domain name in the `From:` field
of email message headers. DMARC is built on top of two existing mechanisms,
Sender Policy Framework (SPF) and DomainKeys Identified Mail (DKIM). It allows
the administrative owner of a domain to publish a policy on which mechanism
(DKIM, SPF or both) is employed when sending email from that domain and how the
receiver should deal with failures. Additionally, it provides a reporting
mechanism of actions performed under those policies. It thus coordinates the
results of DKIM and SPF and specifies under which circumstances the From:
header field, which is often visible to end users, should be considered
legitimate.

#### Adding DNS records

The DNS record to add is of type `TXT`, host as `_dmarc` and value of
`"v=DMARC1; p=none; rua=mailto:someone@test.com"`.

In case this record is not tied to domain `test.com`, for example the domain of
the above record is tied to `example.com`, an extra DNS record on domain
`test.com` is required. It is of type `TXT`, host as
`example.com._report._dmarc` and value of `v=DMARC1;`.

#### Interpretation of reports

- [Aggregate DMARC reports explained](https://www.dmarcanalyzer.com/dmarc-aggregate-reports/)

#### References

- [About DMARC](https://support.google.com/a/answer/2466580)
- [Add a DMARC record](https://support.google.com/a/answer/2466563)
- [Valimail - Domain test on DMARC](https://domain-checker.valimail.com/dmarc/)
- [Yahoo DMARC policy](https://help.yahoo.com/kb/yahoo-dmarc-policy-sln24050.html)
- [Yahoo to Expand Use of Strict DMARC
  Policy](https://dmarc.org/2015/10/yahoo-to-expand-use-of-strict-dmarc-policy/)
- [Email Security Check by gov.uk](https://emailsecuritycheck.service.ncsc.gov.uk/check)

# G Suite

### Migrate from other webmail providers to G Suite

See section *Migrate email from IMAP-based webmail providers* in [Migrate email
to G Suite with the data migration
service](https://support.google.com/a/answer/9476255?hl=en&visit_id=637218572306271204-135647162&rd=1).

### G Suite Toolbox

- [Check MX](https://toolbox.googleapps.com/apps/checkmx/)
- [messageheader](https://toolbox.googleapps.com/apps/messageheader/)

### GMail

- [Apply aliases to recipient addresses](https://support.google.com/a/answer/4524505)

# Microsoft Exchange

### Migration

##### Connect to exchange service and download the remote module

```ps1
Connect-ExchangeOnline -UserPrincipalName your-user@your-domain.com
```

Note: `Install-Module -Name ExchangeOnlineManagement` can be used to install
`Connect-ExchangeOnline`

##### To test connection to source server

```ps1
Test-MigrationServerAvailability -IMAP -RemoteServer imap.some-server.com -Port 993 -Security Ssl
```

##### To create a migration endpoint

```ps1
New-MigrationEndpoint -IMAP -Name IMAPEndpoint -RemoteServer imap.some-server.com -Port 993 -Security Ssl
```

Note that no migration is started at this point of time.

##### To perform a migration

Prepare a `.csv` file like the following.

```csv
EmailAddress,UserName,Password
a@test.com,a@test.com,AStrongPassword
b@test.com,b@test.com,AStrongPassword
c@test.com,c@test.com,AStrongPassword
```

where `EmailAddress` is the email address on exchange and `UserName` is
(normally) the email address on IMAP server.

To start a migration

```ps1
New-MigrationBatch -Name IMAPBatch1 -SourceEndpoint IMAPEndpoint -CSVData ([System.IO.File]::ReadAllBytes("./accounts.csv")) -AutoStart
```

To check a migration process

```ps1
Get-MigrationBatch -Identity IMAPBatch1 | Format-List Status
```

To check all properties of a migration

```ps1
Get-MigrationBatch -Identity IMAPBatch1 | Format-List
```

To check migrations in a web interface, visit https://admin.exchange.microsoft.com/.
Select `Migration` in the menu.

To complete a migration

```ps1
Complete-MigrationBatch -Identity IMAPBatch1
```

To remove a migration

```ps1
Remove-MigrationBatch -Identity IMAPBatch1
```

and to confirm removal has been completed

```ps1
Get-MigrationBatch IMAPBatch1
```

To check mailbox usage

```ps1
Get-EXOMailboxStatistics -Identity someone@test.com
```

### DKIM

Once email migration has been done, setup custom domain in
https://admin.microsoft.com/ in section `Setup` (and select `Set up email
& usernames with a custom domain`). The on-screen instructions will guide you to
create a `TXT` DNS record to verify the ownership.

After the verification and re-login, remove the `TXT` created for verification.
This allows creation of other required `TXT` records. The on-screen instructions
will guide you to create DNS records for MX, SPF and
autodiscover.

```sh
sudo pwsh
```

```ps1
Install-Module -Name PSWSMan
Install-WSMan
exit
```

```sh
pwsh
```

```ps1
Install-Module -Name ExchangeOnlineManagement
Connect-ExchangeOnline -UserPrincipalName your-user@your-domain.com
New-DkimSigningConfig -DomainName your-domain.com -Enabled $false
Get-DkimSigningConfig -Identity your-domain.com | Format-List Selector1CNAME, Selector2CNAME
```

Create two `CNAME` DNS records with the following names

- `selector1._domainkey.your-domain.com`
- `selector2._domainkey.your-domain.com`

and use the result of the commands above as its values.

Once the DNS records have been populated properly, run

```ps1
Set-DkimSigningConfig -Identity your-domain.com -Enabled $true
```

To verify if it is working properly, check the headers of a newly sent mail and
look for `DKIM=pass` or `DKIM=ok`.

### Spam management

- [Spoof Intelligence Insight](https://security.microsoft.com/spoofintelligence)
  where it shows a list of suspected spoofed users.
- [Exchange admin center](https://admin.exchange.microsoft.com/) where in
  section `Rules` under menu item `, a rule of `bypass spam filtering` can be
  added if we want to whitelist a domain
- [Configure outbound spam policies in Exchange Online Protection
  (EOP)](https://learn.microsoft.com/en-us/defender-office-365/outbound-spam-policies-configure)

### PST and OST

- [MS-PST: Outlook Personal Folders (.pst) File
  Format](https://learn.microsoft.com/en-us/openspecs/office_file_formats/ms-pst/141923d5-15ab-4ef1-a524-6dce75aae546)
- [How to configure the size limit for both (.pst) and (.ost) files in
  Outlook](https://support.microsoft.com/en-us/topic/how-to-configure-the-size-limit-for-both-pst-and-ost-files-in-outlook-2f13f558-d40e-9c2a-e3b6-02806fa535f4)

### Configuration

- [Enable-OrganizationCustomization](https://learn.microsoft.com/en-us/powershell/module/exchange/enable-organizationcustomization)


# Troubleshooting

- [Troubleshoot email delivery](https://support.rackspace.com/how-to/troubleshoot-email-delivery/)
- [IP and domain reputation checker](https://check.spamhaus.org/)
