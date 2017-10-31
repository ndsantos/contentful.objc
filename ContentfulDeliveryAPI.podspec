#!/usr/bin/ruby

#require 'dotenv/load'

Pod::Spec.new do |s|
  s.name             = "ContentfulDeliveryAPI"
  s.version          = "2.0.3-local"
  s.summary          = "Objective-C SDK for Contentful's Content Delivery API."
  s.homepage         = "https://github.com/contentful/contentful.objc/"
  s.social_media_url = 'https://twitter.com/contentful'

  s.license = {
    :type => 'MIT',
    :file => 'LICENSE'
  }

  s.authors      = { "Boris Bügling" => "boris@buegling.com", "JP Wright" => "jp@contentful.com" }
  s.source       = { :path => "/Users/ns/Repo/iOS/Libraries/Contentful"
                    }
  s.requires_arc = true

  s.source_files = [
    'ContentfulDeliveryAPI/Resources/*.{h,m}',
    'ContentfulDeliveryAPI/*.{h,m}', 
    'Versions.h'
  ]
  s.public_header_files  = [
    'ContentfulDeliveryAPI/Resources/{CDAArray,CDAAsset,CDAContentType,CDAEntry,CDAError,CDASpace,CDAResource}.h',
    'ContentfulDeliveryAPI/{CDAClient,CDAConfiguration,CDANullabilityStubs,CDARequest,CDAResponse,CDAField,CDASyncedSpace,ContentfulDeliveryAPI,CDAPersistenceManager,CDAPersistedAsset,CDAPersistedEntry,CDAPersistedSpace,CDALocalizablePersistedEntry,CDALocalizedPersistedEntry}.h'
  ]

  s.ios.deployment_target     = '8.0'
  s.ios.source_files          = 'ContentfulDeliveryAPI/UIKit/*.{h,m}'
  s.ios.frameworks            = 'UIKit', 'MapKit'
  s.ios.public_header_files   = 'ContentfulDeliveryAPI/UIKit/{CDAEntriesViewController,CDAFieldsViewController,UIImageView+CDAAsset,CDAMapViewController,CDAResourcesCollectionViewController,CDAResourcesViewController,CDAResourceCell}.h'

  s.tvos.deployment_target = '9.0'
  s.tvos.source_files          = 'ContentfulDeliveryAPI/UIKit/*.{h,m}'
  s.tvos.frameworks            = 'UIKit', 'MapKit'
  s.tvos.public_header_files   = 'ContentfulDeliveryAPI/UIKit/{CDAEntriesViewController,CDAFieldsViewController,UIImageView+CDAAsset,CDAMapViewController,CDAResourcesCollectionViewController,CDAResourcesViewController,CDAResourceCell}.h'
  
  s.osx.deployment_target     = '10.10'
  
  s.watchos.deployment_target = '2.0'
  s.watchos.source_files          = 'ContentfulDeliveryAPI/UIKit/*.{h,m}'
  s.watchos.frameworks            = 'UIKit', 'MapKit'
  s.watchos.public_header_files   = 'ContentfulDeliveryAPI/UIKit/{CDAEntriesViewController,CDAFieldsViewController,UIImageView+CDAAsset,CDAMapViewController,CDAResourcesCollectionViewController,CDAResourcesViewController,CDAResourceCell}.h'

  s.dependency 'AFNetworking', '~> 3.1.0'
  s.dependency 'ISO8601', '~> 0.6.0'
end

