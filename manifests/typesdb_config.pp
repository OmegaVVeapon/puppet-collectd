define typesdb_config(
  $typeDB = $title,
  $config_file,
) {
  validate_absolute_path($config_file)

  Augeas {
    context => "/files/${config_file}/",
  }

  #Make sure the TypesDB directive is present first
  ensure_resource('augeas', 'TypesDB entry', {
      changes => "set directive[last()+1] TypesDB",
      onlyif  => "get directive[. = 'TypesDB'] != TypesDB",
    }
  )
  
  augeas { $typeDB:
    changes => "set directive[. = \'TypesDB\']/arg[last()+1] '\"${typeDB}\"'",
    onlyif  => "get directive/value[. = \'TypesDB\'] != '\"${typeDB}\"'",
  }

  Augeas['TypesDB entry'] -> Augeas[$typeDB]
}
