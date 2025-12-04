let
  pierre-yves = {
    "py.landure@cobredia.fr" =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILg7UMMfh3KAlSvnjDLg8YZDvW7QdShZWy0Q9lYNsZqy";
    "pierre-yves@landure.fr" =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDWk91xtWdVTzO7pSme5GLq7SjfIim5jqPuYqaIwWQGw";
  };
  users = builtins.attrValues pierre-yves;

  co-bre-pc04 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIdGsGpFcZ1kMe3qfqxoilnB34VCMAiorrEixIH8O1/p";
  systems = [ co-bre-pc04 ];

  all = users ++ systems;
in
{
  "secrets/ghost/luks-encryption-key.age".publicKeys = all;
}
