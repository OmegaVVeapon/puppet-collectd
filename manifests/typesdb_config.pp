define collectd::typesdb_config(
  $config_file,
  $typedb = $title,
) {
  validate_absolute_path($config_file)

  Augeas {
    context => "/files/${config_file}/",
  }

  #Make sure the TypesDB directive is present first
  ensure_resource('augeas', 'TypesDB directive', {
      changes => 'set directive[last()+1] TypesDB',
      onlyif  => "get directive[. = 'TypesDB'] != TypesDB",
    }
  )

  augeas { $typedb:
    changes => "set directive[. = \'TypesDB\']/arg[last()+1] '\"${typedb}\"'",
    onlyif  => "get directive/value[. = \'TypesDB\'] != '\"${typedb}\"'",
  }

  Augeas['TypesDB directive'] -> Augeas[$typedb]
}
