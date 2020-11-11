module FactoryBot
  module Syntax
    module Methods
      # 拡張 参照:https://gdgd-shinoyu.hatenablog.com/entry/2018/12/14/025955
      def find_or_create(name, *traits, **attributes, &block)
        klass = FactoryBot.factory_by_name(name).build_class
        attrs = FactoryBot.attributes_for(name, *traits).merge(attributes)

        find_attrs = klass.new(attrs).attributes

        if klass.ancestors.include?(ActiveRecord::Base)
          find_attrs.slice!(*klass.connection.indexes(klass.table_name).select(&:unique).flat_map(&:columns).uniq)
        end
        klass.find_by(find_attrs, &block) || FactoryBot.create(name, attrs, &block)
      end
    end
  end
end
