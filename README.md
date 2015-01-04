rbfam
=====

Light wrapper for RFam data in Ruby. Provides two [`ActiveRecord::Base`](http://api.rubyonrails.org/classes/ActiveRecord/Base.html) models, `Rbfam::Family` and `Rbfam::Rna`. `Rbfam::Rna#seq` objects are cast as [`Bio::Sequence::NA`](http://bioruby.org/rdoc/Bio/Sequence/NA.html), and support any methods provided by that class.

```
Rbfam::Family(id: integer, created_at: datetime, updated_at: datetime, name: string, description: string, consensus_structure: text)
Rbfam::Rna(id: integer, created_at: datetime, updated_at: datetime, family_id: integer, accession: string, sequence: text, gapped_sequence: text, from: integer, to: integer)
```

Versioning follows a variant of semver, where release X.Y.Z.A has RFam major version X, RFam minor version Y, minor version Z and patch level A. 

### Usage

```ruby
require "rbfam"
Rbfam.db.connect

Rbfam::Family.count                             #=> 2450
Rbfam::Rna.count                                #=> 47218

Rbfam::Family.rf(5).name                        #=> "RF00005" 
Rbfam::Family.rf(5).description                 #=> "tRNA"
Rbfam::Family.rf(5).class.superclass            #=> ActiveRecord::Base 
Rbfam::Family.named("microRNA").count           #=> 524 
 
Rbfam::Family.rf(167).rnas.count                #=> 133
Rbfam::Family.rf(167).rnas.plus_strand.count    #=> 76
Rbfam::Family.rf(167).rnas.first.description    #=> "X83878.1/168-267"
Rbfam::Family.rf(167).rnas.first.seq.gc_content #=> (23/50)
Rbfam::Family.rf(167).rnas.first.seq.class      #=> Bio::Sequence::NA
```

### Installation

To install via Rubygems:

```
gem install rbfam
```

To install from source:

```
git clone https://github.com/evansenter/rbfam.git
cd rbfam
bundle install
rake install
```

### Configuration

The default configuration for the database resides in [`db/config.yml`](https://github.com/evansenter/rbfam/blob/master/db/config.yml), but is easily overridable. Rbfam uses the `Rbfam.db.scoped_config` function to access the database, which retrieves the configuration from the `Rbfam.db.config` object, keyed by `Rbfam.db.env`. Both of these functions have writers as well for user-specific configuration.

```ruby
Rbfam.db.scoped_config #=> {"adapter"=>"mysql2", "database"=>"rbfam", "username"=>"root", "password"=>nil} 
Rbfam.db.config        #=> {"rbfam"=>{"adapter"=>"mysql2", "database"=>"rbfam", "username"=>"root", "password"=>nil}} 
Rbfam.db.env           #=> "rbfam" 
```

### Initialization

The first time that you use Rbfam, you need to build and populate the database. This process takes approximately 15 minutes as all the data from Rfam 12.0 is loaded into MySQL. To do this, one does the following:

```ruby
require "rbfam"
Rbfam.db.bootstrap!
```
