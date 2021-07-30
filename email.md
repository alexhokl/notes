- [Mail Server](#mail-server)
    + [SPF](#spf)
    + [DKIM](#dkim)
    + [DMARC](#dmarc)
- [G Suite](#g-suite)
    + [Migrate from other webmail providers to G Suite](#migrate-from-other-webmail-providers-to-g-suite)
    + [G Suite Toolbox](#g-suite-toolbox)
    + [GMail](#gmail)
- [Microsoft Exchange](#microsoft-exchange)
    + [DKIM](#dkim-1)
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

### DKIM

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

# Troubleshooting

- [Troubleshoot email delivery](https://support.rackspace.com/how-to/troubleshoot-email-delivery/)
