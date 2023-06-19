{ config, options, ... }:
{
  options.services.netdata.claim_token_file = options.services.netdata.claimTokenFile;
  config.services.netdata.claim_token_file = config.services.netdata.claimTokenFile;
}
